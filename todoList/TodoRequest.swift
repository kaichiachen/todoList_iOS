import Foundation
import Parse

public class TodoData : AnyObject{
    var detail:String!
    var title:String!
    var itemId:String!
    var havedone:Bool = false
    
    init(detail:String,title:String,itemId:String){
        self.detail = detail
        self.title = title
        self.itemId = itemId
    }
    
    init(detail:String,title:String,itemId:String, haveDone:Bool){
        self.detail = detail
        self.title = title
        self.itemId = itemId
        self.havedone = haveDone
    }
    
    func copy() -> TodoData{
        return TodoData(detail: detail, title: title,itemId: itemId,haveDone: havedone)
    }
}

class TodoRequest{
    static func addTodoItem(title:String, detail:String, finished:(Bool) -> Void){
        let todoObject = PFObject(className: "Todo")
        todoObject["title"] = title
        todoObject["detail"] = detail
        todoObject["facebookid"] = DataCache.shareInstance().getUserLoginData().0
        todoObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            finished(success)
        }
    }
    
    static func changeTodoItem(objId:String,title:String, detail:String, haveDone:Bool, finished:(Bool) -> Void){
        let query:PFQuery = PFQuery(className: haveDone ? "havedo":"Todo")
        query.getObjectInBackgroundWithId(objId){
            object in
            let todoObject = object.0!
            todoObject.setObject(title, forKey: "title")
            todoObject.setObject(detail, forKey: "detail")
            todoObject.saveInBackground()
            finished(true)
        }
    }
    
    static func fetchList(finished:((RequestResponse<[TodoData]>) -> Void)){
        let data = DataCache.shareInstance().getUserLoginData()
        var todoList = [TodoData]()
            
        let query:PFQuery = PFQuery(className: "Todo")
        query.whereKey("facebookid", equalTo: (data.0 ))
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
            response in
            if response.0 {
                finished(true)
            } else {
                
            }
        }
    }
    
    static func moveToHaveDone(objId:String,finished:(Bool) -> Void){
        let query:PFQuery = PFQuery(className: "Todo")
        query.whereKey("objectId", equalTo: (objId ))
        query.findObjectsInBackgroundWithBlock(){
            block in
            if let data = block.0?[0] {
                let haveDoneobj = TodoData(detail: (data["detail"] as! String), title: (data["title"] as! String), itemId: data.objectId!, haveDone: true)
                HaveDoneRequest.addHaveDoneItem(haveDoneobj.title, detail: haveDoneobj.detail){
                    success in
                    if success {
                        deleteItem(haveDoneobj.itemId){
                            success in
                            finished(success)
                        }
                    }
                }
            }
            
            
        }
    }
}