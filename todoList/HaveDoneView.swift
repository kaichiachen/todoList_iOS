import UIKit

class HaveDoneView:UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.scrollEnabled = true
        }
    }
    
    var todoList = [TodoData]()
    var context:UIViewController!
    func initialize(context:UIViewController){
        self.context = context
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getHaveDone:", name: "recieve havedone data", object: nil)
    }
    
    func deleteItem(index:Int){
        todoList.removeAtIndex(index)
        tableView.reloadData()
    }
    
    func getHaveDone(notification: NSNotification){
        if let todoData = notification.userInfo?["data"] as? [TodoData]{
            todoList.removeAll()
            for node in todoData{
                todoList.append(node)
            }
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = context.storyboard!.instantiateViewControllerWithIdentifier("addtodoitem") as! AddTodoItemController
        detail.type = HandleType.edit
        detail.todoData = todoList[indexPath.row]
        detail.navigationItem.title = "詳細資訊"
        
        context.navigationController!.pushViewController(detail, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = loadFromNibNamed("OverView",index: 2)!
        cell.setup(todoList[indexPath.row],index: indexPath.row)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func loadFromNibNamed(nibNamed: String, index:Int) -> ListCell? {
        return UINib(
            nibName: nibNamed,
            bundle: nil
            ).instantiateWithOwner(nil, options: nil)[index] as? ListCell
    }
}