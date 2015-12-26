import UIKit

class BasicViewController: UIViewController, DataProtocol {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        DataController.shareInstance().dataSource = self
    }
    
    func fetchedHaveDone(data:[TodoData]){
        NSNotificationCenter.defaultCenter().postNotificationName("recieve havedone data", object: nil, userInfo: ["data":data])
    }
    func fetchedToDo(data:[TodoData]){
        NSNotificationCenter.defaultCenter().postNotificationName("recieve todo data", object: nil, userInfo: ["data":data])
    }
    
    func finishTodoItem() {
        DataController.shareInstance().getTodoList()
        DataController.shareInstance().getHaveDoneList()
    }
    func fetchedDataFail(type:DataType,error:String){
        
    }
}