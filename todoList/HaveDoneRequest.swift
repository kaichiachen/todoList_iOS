import Foundation
import Parse


class HaveDoneRequest : NSObject{
    
    static func addHaveDoneItem(title:String, detail:String, finished:(Bool) -> Void){
        let todoObject = PFObject(className: "havedo")
        todoObject["title"] = title
        todoObject["detail"] = detail
        todoObject["facebookid"] = DataCache.shareInstance().getUserLoginData()
        todoObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            finished(success)
        }
    }

    /**
     fetch have done item list
     
     - parameter finished: callback data
     */
    static func fetchList(finished:((RequestResponse<[TodoData]>) -> Void)){
        let data = DataCache.shareInstance().getUserLoginData()
        var haveDoneList = [TodoData]()
        
        let query:PFQuery = PFQuery(className: "havedo")
        query.whereKey("facebookid", equalTo: (data ))
        query.findObjectsInBackgroundWithBlock(){
            block in
            for node in block.0! {
                haveDoneList.append(TodoData(detail: (node["detail"] as! String),title: (node["title"] as! String), itemId:(node.objectId!),haveDone:true))
            }
            finished(RequestResponse.Success(haveDoneList))
        }
    }
    
    static func deleteItem(objId:String,finished:(Bool) -> Void){
        let oj:PFObject = PFObject(withoutDataWithClassName: "havedo", objectId: objId)
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
}