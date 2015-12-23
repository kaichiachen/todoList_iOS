import UIKit
import FBSDKCoreKit
import Parse

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
}