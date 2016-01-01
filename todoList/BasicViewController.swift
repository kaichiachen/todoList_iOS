import UIKit
import Parse
import FBSDKLoginKit

class BasicViewController: UIViewController, DataProtocol {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        DataController.shareInstance().dataSource = self
    }
    
    func loginSuccess(data: NSDictionary) {
        Log("Login Success!")
    }
    
    func fetchedHaveDone(data:[TodoData]){
        NSNotificationCenter.defaultCenter().postNotificationName("recieve havedone data", object: nil, userInfo: ["data":data])
    }
    func fetchedToDo(data:[TodoData]){
        NSNotificationCenter.defaultCenter().postNotificationName("recieve todo data", object: nil, userInfo: ["data":data])
    }
    
    /**
     transfer todo item to have done item
     */
    func finishTodoItem() {
        DataController.shareInstance().getTodoList()
        DataController.shareInstance().getHaveDoneList()
    }
    
    func fetchedDataFail(type:DataType,error:String){
        Log("\(type): error")
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("networkerror", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func logout() {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "logout", object: nil))
        DataCache.shareInstance().logout()
        FBSDKLoginManager().logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
        UIApplication.sharedApplication().keyWindow?.rootViewController = vc
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Log("didReceiveMemoryWarning")
        if (self.view.window == nil) {
            self.view = nil
        }
        
    }
}