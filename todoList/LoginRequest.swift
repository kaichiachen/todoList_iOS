import Foundation
import FBSDKLoginKit

class LoginRequest {
    
    static func execute(finished:(RequestResponse<NSDictionary>) -> Void){
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,picture.width(100).height(100)"]).startWithCompletionHandler(){
            connection,result,error in
            if (error != nil) {
                print("error: \(error)")
            } else {
                finished(RequestResponse.Success(result as! NSDictionary))
            }
        }
    }
}