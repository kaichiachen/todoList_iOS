import UIKit

class MenuViewController:BasicViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .None
            tableView.showsHorizontalScrollIndicator = false
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.masksToBounds = true
            profileImage.layer.cornerRadius = profileImage.frame.width/2
        }
    }
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let personalData = DataCache.shareInstance().getUserPersonalInfo()
        userName.text = personalData.0
        profileImage.image = UIImage(data: personalData.1)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    let menuTextList = ["登出"]
    let menuIconList = ["logout"]
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: logout()
        default: break
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = menuTextList[indexPath.row]
        cell.imageView?.image = UIImage(named: menuIconList[indexPath.row])
        cell.selectionStyle = .None
        return cell
    }
}