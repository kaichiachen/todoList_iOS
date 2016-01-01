import UIKit

class ListCell:UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBAction func doneClick(sender: AnyObject) {
        DataController.shareInstance().finishTodoItem(itemId)
    }
    
    @IBAction func deleteClick(sender: AnyObject) {
        if todoData.havedone {
            DataController.shareInstance().deleteHaveDoneItem(itemId)
            (self.superview?.superview?.superview as! HaveDoneView).deleteItem(index)
        } else {
            DataController.shareInstance().deleteTodoItem(itemId)
            (self.superview?.superview?.superview as! TodoView).deleteItem(index)
        }
    }
    @IBOutlet weak var deleteButtonWidth: NSLayoutConstraint! {
        didSet{
            deleteButtonWidth.constant = 0
            originWidth = deleteButtonWidth.constant
            self.layoutIfNeeded()
        }
    }
    let maxWidth:CGFloat = 50  /// delete and finish button's max width
    let minWidth:CGFloat = 0   /// delete and finish button's min width
    var originWidth:CGFloat = 0 /// delete and finish button's origin width
    var itemId:String = ""
    var index:Int = -1
    var todoData:TodoData!
    
    /**
     set cell data
     
     - parameter data:  item data
     - parameter index: item index
     */
    func setup(data:TodoData, index:Int) {
        title.text = data.title
        detail.text = data.detail
        itemId = data.itemId
        self.todoData = data
        self.index = index
        if todoData.havedone {
            finishButton.alpha = 0
        }
        let screenEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "scroll:")
        screenEdgePanGesture.edges = UIRectEdge.Right
        self.addGestureRecognizer(screenEdgePanGesture)
        cellPanGesture = UIPanGestureRecognizer(target: self, action: "scroll:")
    }
    
    var cellPanGesture:UIPanGestureRecognizer!
    
    /**
     pan gesture for cell
     
     - parameter sender: sender
     */
    func scroll(sender:UIPanGestureRecognizer){
        let offset = sender.translationInView(self).x * (todoData.havedone ? 0.8:0.4)
        switch sender.state {
        case .Began: break
        case .Changed:
            if originWidth - offset > maxWidth {
                deleteButtonWidth.constant = maxWidth
            } else if originWidth - offset < minWidth {
                deleteButtonWidth.constant = minWidth
            } else {
                deleteButtonWidth.constant = originWidth - offset
            }
            self.layoutIfNeeded()
        case .Ended:
            if deleteButtonWidth.constant > maxWidth/2 {
                deleteButtonWidth.constant = maxWidth
                self.addGestureRecognizer(cellPanGesture)
            } else {
                deleteButtonWidth.constant = minWidth
                self.removeGestureRecognizer(cellPanGesture)
            }
            UIView.animateWithDuration(0.3, animations: {
                self.layoutIfNeeded()
            })
            originWidth = deleteButtonWidth.constant
        default: break
        }
    }
}