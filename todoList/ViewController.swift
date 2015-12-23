import UIKit
import FBSDKLoginKit

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

