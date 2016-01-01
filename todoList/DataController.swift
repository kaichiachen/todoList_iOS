import Foundation
import FBSDKLoginKit
import Parse

public class DataController : NSObject{
    private static var dataManager:DataController?
    private static var lockObject = NSLock()
    public var dataSource:DataProtocol?
    
    override init(){
        super.init()
    }
    
    public static func shareInstance() -> DataController {
        
        /// prevent race condition
        lockObject.lock()
        if dataManager == nil {
            dataManager = DataController()
            if respondsToSelector("cancelRequest:") {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("cancelRequest:"), name: "logout", object: nil)
            }
        }
        lockObject.unlock()
        return dataManager!
    }
    
    func login() {
        LoginRequest.execute(){ response in
            switch response {
            case let .Success(data):
                let id = data["id"] as! String
                let name = data["name"] as! String
                var imageData:NSData? = nil
                let picture = data["picture"] as? NSDictionary
                let pictureData = picture?["data"] as? NSDictionary
                if let str = pictureData?["url"] as? String{
                    if let url = NSURL(string: str) {
                        imageData = NSData(contentsOfURL: url)
                    }
                }
                let query:PFQuery = PFQuery(className: "User")
                query.whereKey("facebookid", equalTo: (id ))
                query.findObjectsInBackgroundWithBlock(){
                    block in
                    if block.0!.count == 0 {
                        let userObject = PFObject(className: "User")
                        userObject["facebookid"] = "\((id ))"
                        userObject["username"] = "\((name ))"
                        userObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            if success {
                                DataCache.shareInstance().setUserLoginData(id)
                                DataCache.shareInstance().setUserPersonalInfo(name,userPicture: imageData ?? NSData())
                                self.dataSource?.loginSuccess(data)
                            } else {
                                self.dataSource?.fetchedDataFail(.ToDo, error: "sign up user fail")
                            }
                        }
                    } else {
                        DataCache.shareInstance().setUserLoginData(id)
                        DataCache.shareInstance().setUserPersonalInfo(name,userPicture: imageData ?? NSData())
                        self.dataSource?.loginSuccess(data)
                    }
                }
            case let .Error(error):
                self.dataSource?.fetchedDataFail(.ToDo, error: error)
            }
        }
        
    }
    
    func addTodoItem(title:String, detail:String){
        TodoRequest.addTodoItem(title,detail: detail){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                if response {
                    self.Log("add todo data success")
                    DataController.shareInstance().getTodoList()
                } else {
                    self.Log("add todo data fail")
                }
            }
        }
    }
    
    func editTodoItem(objid:String, title:String, detail:String, haveDone:Bool){
        TodoRequest.changeTodoItem(objid, title: title,detail: detail,haveDone: haveDone){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                if response {
                    if haveDone {
                        self.Log("edit have done data success")
                        DataController.shareInstance().getHaveDoneList()
                    } else {
                        self.Log("edit have todo data success")
                        DataController.shareInstance().getTodoList()
                    }
                } else {
                    self.Log("change data error")
                }
            }
        }
    }
    
    func getTodoList(){
        TodoRequest.fetchList(){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                    switch response {
                    case let .Success(data):
                        self.Log("fetchedToDoData")
                        self.dataSource?.fetchedToDo(data)
                    case let .Error(error):
                        self.dataSource?.fetchedDataFail(.ToDo, error: error)
                }
            }
        }
    }
    
    func deleteTodoItem(objId:String){
        TodoRequest.deleteItem(objId){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                if response {
                    self.Log("delete todo data success")
                } else {
                    self.Log("delete todo data fail")
                }
            }
        }
    }
    
    func getHaveDoneList(){
        HaveDoneRequest.fetchList(){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                switch response {
                case let .Success(data):
                    self.Log("fetchedHaveDoneData")
                    self.dataSource?.fetchedHaveDone(data)
                case let .Error(error):
                    self.dataSource?.fetchedDataFail(.ToDo, error: error)
                }
            }
        }
    }
    
    func deleteHaveDoneItem(objId:String){
        HaveDoneRequest.deleteItem(objId){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                if response {
                    self.Log("delete have done data success")
                } else {
                    self.Log("delete fail")
                }
            }
        }
    }
    
    func finishTodoItem(objId:String){
        TodoRequest.moveToHaveDone(objId){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                if response {
                    self.Log("move todo to havedone success 🐱🐶")
                    self.dataSource?.finishTodoItem()
                } else {
                    
                }
            }
        }
    }
    
    
    /**
     NSNotification logout
     
     - parameter notification: para
     */
    static public func cancelRequest(notification:NSNotification) {
        Log("logout😈😈😈")
        dataManager = nil
    }
}
