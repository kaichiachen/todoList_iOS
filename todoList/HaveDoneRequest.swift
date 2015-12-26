import Foundation
import Parse


class HaveDoneRequest{
    static func fetchList(finished:((RequestResponse<[TodoData]>) -> Void)){
        let data = DataCache.shareInstance().getUserLoginData()
        var haveDoneList = [TodoData]()
        
        let query:PFQuery = PFQuery(className: "havedo")
        query.whereKey("facebookid", equalTo: (data.0 ))
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
            response in
            if response.0 {
                
            } else {
                
            }
        }
    }
}