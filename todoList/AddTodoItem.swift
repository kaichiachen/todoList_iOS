import UIKit

enum HandleType {
    case add
    case edit
}

/// add, edit item
class AddTodoItemController:UIViewController {
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBOutlet weak var detailTextField: UITextView! {
        didSet {
            detailTextField.layer.borderWidth = 2
            detailTextField.layer.borderColor = UIColor.flatGreenColor().CGColor
            detailTextField.layer.masksToBounds = true
            detailTextField.layer.cornerRadius = 10
        }
    }
    
    
    @IBAction func complete(sender: AnyObject) {
        switch type {
        case .add:
            DataController.shareInstance().addTodoItem(titleTextField.text!, detail: detailTextField.text)
        case .edit:
            DataController.shareInstance().editTodoItem(todoData!.itemId, title: titleTextField.text!, detail: detailTextField.text,haveDone: todoData!.havedone)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var type:HandleType = .add
    var todoData:TodoData?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.text = todoData?.title ?? ""
        detailTextField.text = todoData?.detail ?? ""
    }
}