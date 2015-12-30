import UIKit
import FBSDKLoginKit

class MenuViewController:BasicViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = DataCache.shareInstance().getUserPersonalInfo()
    }
    
    let menuTextList = ["登出"]
    let menuIconList = ["logout"]
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            FBSDKLoginManager().logOut()
            FBSDKAccessToken.setCurrentAccessToken(nil)
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
            UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
            UIApplication.sharedApplication().keyWindow?.rootViewController = vc
        default: break
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = menuTextList[indexPath.row]
        cell.imageView?.image = UIImage(named: menuIconList[indexPath.row])
        return cell
    }
}