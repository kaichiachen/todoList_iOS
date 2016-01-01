import UIKit
import FBSDKCoreKit
import Parse

class ListViewController: BasicViewController ,UIScrollViewDelegate {
    
    
    @IBAction func openMenu(sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    @IBAction func addTodoList(sender: AnyObject) {
    }
    @IBOutlet weak var greenBarLeading: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView! {
        didSet{
            mainScrollView.delegate = self
            mainScrollView.pagingEnabled = true
            mainScrollView.scrollEnabled = false
            mainScrollView.showsHorizontalScrollIndicator = false
            mainScrollView.showsVerticalScrollIndicator = false
        }
    }
    

    @IBAction func toDoButton(sender: AnyObject) {
        mainScrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        greenBarLeading.constant = -20
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func haveDoneButton(sender: AnyObject) {
        mainScrollView.setContentOffset(CGPoint(x: pageWidth,y: 0), animated: true)
        greenBarLeading.constant = Utils.getScreenWidth()/2 - 20
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }

    var UIViewList = [UIView]() /// todo and havedone view
    var pageWidth:CGFloat = 1
    var pageHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataController.shareInstance().getTodoList()
        DataController.shareInstance().getHaveDoneList()
    }
    var initialize = false
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if initialize {
            return
        } else {
            initialize = true
        }
        
        /**
        *  set todo and havedone list view
        */
        pageWidth = mainScrollView.frame.width
        pageHeight = mainScrollView.frame.height
        for i in 0..<2 {
            if let view = loadFromNibNamed("OverView", index: i) {
                view.frame = CGRectMake(CGFloat(i)*pageWidth, 0, pageWidth, pageHeight)
                UIViewList.append(view)
                mainScrollView.addSubview(view)
            } else {
                return
            }
        }
        (UIViewList[0] as! TodoView).initialize(self)
        (UIViewList[1] as! HaveDoneView).initialize(self)
        mainScrollView.contentSize = CGSize(width: pageWidth*2, height: pageHeight)
    }
    
    func loadFromNibNamed(nibNamed: String, index:Int) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: nil
            ).instantiateWithOwner(nil, options: nil)[index] as? UIView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffSetX = scrollView.contentOffset.x
        let page = currentOffSetX / pageWidth
        if Float(page) - Float(Int(page)) == 0 {
            switch Int(page) {
            case 0:
                greenBarLeading.constant = -20
                UIView.animateWithDuration(0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            case 1:
                greenBarLeading.constant = Utils.getScreenWidth()/2 - 20
                UIView.animateWithDuration(0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            default: break
            }
        }
    }
}