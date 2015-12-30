import UIKit
import Parse

class BasicViewController: UIViewController, DataProtocol {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        DataController.shareInstance().dataSource = self
    }
    
    func loginSuccess(data: NSDictionary) {
        let id = data["id"] as! String
        let name = data["name"] as! String
        
        let query:PFQuery = PFQuery(className: "User")
        do {
            let object:NSArray = try query.findObjects()
            PFObject.pinAllInBackground(object as? [PFObject])
            query.fromLocalDatastore()
            query.whereKey("facebookid", equalTo: (id ))
            query.findObjectsInBackgroundWithBlock(){
                block in
                if block.0!.count == 0 {
                    let userObject = PFObject(className: "User")
                    userObject["facebookid"] = "\((id ))"
                    userObject["username"] = "\((name ))"
                    userObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    }
                }
                
            }
        } catch _ {
            
        }
        DataCache.shareInstance().setUserLoginData(id)
        DataCache.shareInstance().setUserPersonalInfo(name)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if (self.view.window == nil) {
            self.view = nil
        }
        
    }
}