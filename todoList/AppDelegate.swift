import UIKit
import FBSDKCoreKit
import Parse
import Bolts
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Parse.enableLocalDatastore()
        Parse.setApplicationId("0rQEriLUmiwWYn4ddii54AyNELYoMZJ1UoTqmVHT",
            clientKey: "T1tkdW7tO4X4ouBU8H3hGe9nDujhLRiKceweZukA")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    /**
     set slide menu function
     
     - parameter storyBoard: storyboard
     
     - returns: slide menu controller
     */
    func setSlideView(storyBoard:UIStoryboard) -> SlideMenuController {
        SlideMenuOptions.contentViewScale = 1.0
        let mainViewController = storyBoard.instantiateViewControllerWithIdentifier("nav") as! UINavigationController
        
        let menuViewController:UIViewController = storyBoard.instantiateViewControllerWithIdentifier("menu") as! MenuViewController
        
        let slideMenuController = SlideMenuController(mainViewController:mainViewController, leftMenuViewController: menuViewController)
        
        return slideMenuController
        
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

