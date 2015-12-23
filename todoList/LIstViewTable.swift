import UIKit
import FBSDKCoreKit

class ListViewTable: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler(){
                connection,result,error in
                if (error != nil) {
                    print("error: \(error)")
                } else {
                    let id = result["id"]
                    print("result: \(id)")
                }
            }
        }
        
        
        if FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions") {
            FBSDKGraphRequest(graphPath: "me/feed", parameters: ["message":"hello world"], HTTPMethod: "POST").startWithCompletionHandler(){
                connection,result,error in
                if (error != nil) {
                    print("error: \(error)")
                } else {
                    let id = result["id"]
                    print("result: \(id)")
                }
            }
        }else {
            print("need granted")
        }
    }
}