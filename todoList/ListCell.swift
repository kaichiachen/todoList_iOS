import UIKit

class ListCell:UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    
    @IBAction func doneClick(sender: AnyObject) {
        print(itemId)
    }
    
    @IBAction func deleteClick(sender: AnyObject) {
        DataController.shareInstance().deleteTodoItem(itemId)
        (self.superview?.superview?.superview as! TodoView).deleteItem(index)
    }
    @IBOutlet weak var deleteButtonWidth: NSLayoutConstraint! {
        didSet{
            deleteButtonWidth.constant = 0
            originWidth = deleteButtonWidth.constant
            self.layoutIfNeeded()
        }
    }
    let maxWidth:CGFloat = 50
    let minWidth:CGFloat = 0
    var originWidth:CGFloat = 0
    var itemId:String = ""
    var index:Int = -1
    func setup(data:TodoData, index:Int) {
        title.text = data.title
        detail.text = data.detail
        itemId = data.itemId
        self.index = index
        let gesture = UIPanGestureRecognizer(target: self, action: "scroll:")
        cellView.addGestureRecognizer(gesture)
    }
    
    func scroll(sender:UIPanGestureRecognizer){
        let offset = sender.translationInView(self).x * 0.4
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
            } else {
                deleteButtonWidth.constant = minWidth
            }
            UIView.animateWithDuration(0.3, animations: {
                self.layoutIfNeeded()
            })
            originWidth = deleteButtonWidth.constant
        default: break
        }
    }
}