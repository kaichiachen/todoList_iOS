import UIKit
import FBSDKLoginKit
import Parse
import SlideMenuControllerSwift

class LoginViewController: UIViewController {

    
    var token:String? = nil
    let width = UIScreen.mainScreen().bounds.width
    let height = UIScreen.mainScreen().bounds.height
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton:UIButton = {
            let loginButton:UIButton = UIButton(type: UIButtonType.Custom)
            loginButton.center = self.view.center
            loginButton.backgroundColor = UIColor.flatGreenColorDark()
            loginButton.frame = CGRectMake(width/2 - 90,180,180,40)
            loginButton.layer.masksToBounds = true
            loginButton.layer.cornerRadius = 5
            loginButton.setTitle("Facebook Login", forState: UIControlState.Normal)
            
            loginButton.addTarget(self, action: "click", forControlEvents: UIControlEvents.TouchUpInside)
            return loginButton
        }()
        
        self.view.addSubview(loginButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if token != nil || DataCache.shareInstance().isLogin(){
            self.performSegueWithIdentifier("main", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let slideMenuController = appDelegate.setSlideView(storyboard)
        appDelegate.window?.rootViewController = slideMenuController
    }
    
    func click(){
        let login:FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile"], fromViewController: self, handler: { result, error in
            if (error != nil) {
                print("error: \(error)")
            } else {
                if result.token != nil {
                    self.token = result.token.tokenString
                    self.fetchUserData()
                }
            }
        })
    }
    
    func fetchUserData(){
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler(){
                connection,result,error in
                if (error != nil) {
                    print("error: \(error)")
                } else {
                    let id = result["id"] as! String
                    let name = result["name"]
                    print("result: \(id)")
                    
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
                                userObject["username"] = "\((name as! String))"
                                userObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                                }
                            }
                            
                        }
                    } catch _ {
                        
                    }
                    DataCache.shareInstance().setUserLoginData(id, token: self.token!)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

