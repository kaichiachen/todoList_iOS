import UIKit
import FBSDKLoginKit
import Parse
import SlideMenuControllerSwift
import GCNetworkReachability
import NVActivityIndicatorView

class LoginViewController: BasicViewController {

    @IBOutlet weak var loginTitle: UILabel!
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
            loginButton.layer.masksToBounds = true
            loginButton.layer.cornerRadius = 5
            loginButton.setTitle(NSLocalizedString("facebooklogin", comment: ""), forState: UIControlState.Normal)
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
            view.alpha = 0
            return view
            }()
        
        self.view.addSubview(indicator)
        
        setAutoLayout()
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
    
    func setAutoLayout(){
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Top, relatedBy: .Equal, toItem: loginTitle, attribute: .Bottom, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .CenterX, relatedBy: .Equal, toItem: loginTitle, attribute: .CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 180))
        view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40))
        
        view.addConstraint(NSLayoutConstraint(item: indicator, attribute: .Top, relatedBy: .Equal, toItem: loginTitle, attribute: .Bottom, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: indicator, attribute: .CenterX, relatedBy: .Equal, toItem: loginTitle, attribute: .CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: indicator, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
        view.addConstraint(NSLayoutConstraint(item: indicator, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
    }
    
    /**
     selector of fb login button click function
     */
    func click(){
        guard GCNetworkReachability.reachabilityForInternetConnection().isReachable()  else {
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("networkerror", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        loginButton.removeFromSuperview()
        indicator.startAnimation()
        indicator.alpha = 1
        
        let login:FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile"], fromViewController: self, handler: { result, error in
            if error != nil || result.token == nil {
                let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("loginerror", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.indicator.alpha = 0
                self.loginButton.alpha = 1
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
            self.indicator.alpha = 0
            if DataCache.shareInstance().isLogin(){
                self.performSegueWithIdentifier("main", sender: self)
            }
        }
    }
}

