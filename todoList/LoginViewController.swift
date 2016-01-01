import UIKit
import FBSDKLoginKit
import Parse
import SlideMenuControllerSwift
import GCNetworkReachability
import NVActivityIndicatorView

class LoginViewController: BasicViewController {

    @IBOutlet weak var loginTitleHeight: NSLayoutConstraint!
    
    var indicator:NVActivityIndicatorView!
    var loginButton:UIButton!
    
    var token:String? = nil
    let width = UIScreen.mainScreen().bounds.width
    let height = UIScreen.mainScreen().bounds.height
    override func viewDidLoad() {
        super.viewDidLoad()
        guard !DataCache.shareInstance().isLogin() else { return }
        
        /**
        *  set fb login button
        */
        loginButton = {
            let loginButton:UIButton = UIButton(type: UIButtonType.Custom)
            loginButton.center = self.view.center
            loginButton.backgroundColor = UIColor.flatBlueColor()
            loginButton.frame = CGRectMake(width/2 - 90,250,180,40)
            loginButton.layer.masksToBounds = true
            loginButton.layer.cornerRadius = 5
            loginButton.setTitle("Facebook Login", forState: UIControlState.Normal)
            loginButton.addTarget(self, action: "click", forControlEvents: UIControlEvents.TouchUpInside)
            return loginButton
        }()
        
        self.view.addSubview(loginButton)
        
        /**
        *  set loading view
        */
        indicator = {
            let view = NVActivityIndicatorView(frame: CGRectMake(width/2 - 50,250,100,100))
            view.type = .Pacman
            view.color = UIColor.flatBlueColor()
            return view
            }()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if DataCache.shareInstance().isLogin(){
            /**
            effect
            */
            NSThread.sleepForTimeInterval(2)
            self.performSegueWithIdentifier("main", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let slideMenuController = appDelegate.setSlideView(storyboard)
        appDelegate.window?.rootViewController = slideMenuController
    }
    
    /**
     selector of fb login button click function
     */
    func click(){
        guard GCNetworkReachability.reachabilityForInternetConnection().isReachable()  else {
            let alert = UIAlertController(title: "錯誤", message: "連不上網路", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        loginButton.removeFromSuperview()
        indicator.startAnimation()
        self.view.addSubview(indicator)
        
        let login:FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile"], fromViewController: self, handler: { result, error in
            if error != nil || result.token == nil {
                let alert = UIAlertController(title: "錯誤", message: "登入有誤", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.indicator.removeFromSuperview()
                self.view.addSubview(self.loginButton)
            } else {
                self.token = result.token.tokenString
                self.fetchUserData()
            }
        })
    }
    
    func fetchUserData(){
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            DataController.shareInstance().login()
        }
    }
    
    override func loginSuccess(data: NSDictionary) {
        super.loginSuccess(data)
        dispatch_async(dispatch_get_main_queue()) {
            self.indicator.removeFromSuperview()
            if DataCache.shareInstance().isLogin(){
                self.performSegueWithIdentifier("main", sender: self)
            }
        }
    }
    
}

