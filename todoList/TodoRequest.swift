import Foundation
import Parse

public class TodoData : NSObject, NSCopying{
    var detail:String!
    var title:String!
    var itemId:String!
    var havedone:Bool = false
    
    /**
     todo init
     
     - parameter detail: detail
     - parameter title:  title
     - parameter itemId: itemId
     
     - returns: initial
     */
    init(detail:String,title:String,itemId:String){
        self.detail = detail
        self.title = title
        self.itemId = itemId
    }
    
    /**
     have done data init
     
     - parameter detail:   detail
     - parameter title:    title
     - parameter itemId:   itemId
     - parameter haveDone: bool
     
     - returns: initial
     */
    init(detail:String,title:String,itemId:String, haveDone:Bool){
        self.detail = detail
        self.title = title
        self.itemId = itemId
        self.havedone = haveDone
    }
    
    /**
     for copy() function
     pass by value
     
     - parameter zone: nil
     
     - returns: TodoData object
     */
    public func copyWithZone(zone: NSZone) -> AnyObject {
        return TodoData(detail: detail, title: title,itemId: itemId,haveDone: havedone)
    }
}

class TodoRequest:NSObject{
    

    static func addTodoItem(title:String, detail:String, finished:(Bool) -> Void){
        let todoObject = PFObject(className: "Todo")
        todoObject["title"] = title
        todoObject["detail"] = detail
        todoObject["facebookid"] = DataCache.shareInstance().getUserLoginData()
        todoObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            finished(success)
        }
    }
    
    static func changeTodoItem(objId:String,title:String, detail:String, haveDone:Bool, finished:(Bool) -> Void){
        let query:PFQuery = PFQuery(className: haveDone ? "havedo":"Todo")
        query.getObjectInBackgroundWithId(objId){
            object in
            if let error = object.1 {
                Log(error)
                finished(false)
            } else if let todoObject = object.0 {
                todoObject.setObject(title, forKey: "title")
                todoObject.setObject(detail, forKey: "detail")
                todoObject.saveInBackground()
                finished(true)
            } else {
                finished(false)
            }
        }
    }
    
    /**
     fetch todo item list
     
     - parameter finished: callback data
     */
    static func fetchList(finished:((RequestResponse<[TodoData]>) -> Void)){
        let data = DataCache.shareInstance().getUserLoginData()
        var todoList = [TodoData]()
            
        let query:PFQuery = PFQuery(className: "Todo")
        query.whereKey("facebookid", equalTo: (data ))
        query.findObjectsInBackgroundWithBlock(){
            block in
            for node in block.0! {
                todoList.append(TodoData(detail: (node["detail"] as! String),title: (node["title"] as! String), itemId:(node.objectId!)))
            }
            finished(RequestResponse.Success(todoList))
        }
    }
    
    static func deleteItem(objId:String,finished:(Bool) -> Void){
        let oj:PFObject = PFObject(withoutDataWithClassName: "Todo", objectId: objId)
        oj.deleteInBackgroundWithBlock(){
            object in
            if let error = object.1 {
                Log(error)
                finished(false)
            } else if object.0 {
                finished(true)
            } else {
                finished(false)
            }
        }
    }
    
    /**
     move item to have done when user finish todo item
     
     - parameter objId:    item id
     - parameter finished: callback success
     */
    static func moveToHaveDone(objId:String,finished:(Bool) -> Void){
        let query:PFQuery = PFQuery(className: "Todo")
        query.whereKey("objectId", equalTo: (objId ))
        query.findObjectsInBackgroundWithBlock(){
            block in
            if let error = block.1{
                Log(error)
                finished(false)
            } else if let data = block.0?[0] {
                let haveDoneobj = TodoData(detail: (data["detail"] as! String), title: (data["title"] as! String), itemId: data.objectId!, haveDone: true)
                HaveDoneRequest.addHaveDoneItem(haveDoneobj.title, detail: haveDoneobj.detail){
                    success in
                    if success {
                        deleteItem(haveDoneobj.itemId){
                            success in
                            if success {
                                finished(true)
                            } else {
                                self.Log("delete todo item fail")
                                finished(false)
                            }
                        }
                    } else {
                        self.Log("add have done item fail")
                        finished(false)
                    }
                }
            } else {
                self.Log("no todo item fail")
                finished(false)
            }
        }
    }
}