import UIKit
import FBSDKLoginKit
import Parse

class ViewController: UIViewController {

    
    var token:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton:UIButton = UIButton(type: UIButtonType.Custom)
        loginButton.center = self.view.center
        loginButton.backgroundColor = UIColor.grayColor()
        loginButton.frame = CGRectMake(20,20,180,40)
        loginButton.setTitle("login", forState: UIControlState.Normal)
        //loginButton.readPermissions = ["public_profile","email"]
        
        loginButton.addTarget(self, action: "click", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(loginButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if token != nil {
            self.performSegueWithIdentifier("main", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        DataCache.shareInstance().setUserToken(self.token!)
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler(){
                connection,result,error in
                if (error != nil) {
                    print("error: \(error)")
                } else {
                    let id = result["id"]!
                    let name = result["name"]
                    print("result: \(id)")
                    
                    let query:PFQuery = PFQuery(className: "User")
                    do {
                        let object:NSArray = try query.findObjects()
                        PFObject.pinAllInBackground(object as? [PFObject])
                        query.fromLocalDatastore()
                        query.whereKey("facebookid", equalTo: (id as! String))
                        query.findObjectsInBackgroundWithBlock(){
                            block in
                            if block.0!.count == 0 {
                                let testObject = PFObject(className: "User")
                                testObject["facebookid"] = "\((id as! String))"
                                testObject["username"] = "\((name as! String))"
                                testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                                    print("Object has been saved.")
                                }
                            }
                            
                        }
                    } catch _ {
                        
                    }
                }
            }
        }
    }
    
    func click(){
        let login:FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile"], fromViewController: self, handler: { result, error in
            if (error != nil) {
                print("error: \(error)")
            } else {
                if result.token != nil {
                    self.token = result.token.tokenString
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

