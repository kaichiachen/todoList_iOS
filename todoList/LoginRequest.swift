import Foundation
import FBSDKLoginKit

class LoginRequest {
    static func execute(finished:(RequestResponse<NSDictionary>) -> Void){
        FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler(){
            connection,result,error in
            if (error != nil) {
                print("error: \(error)")
            } else {
                finished(RequestResponse.Success(result as! NSDictionary))
            }
        }
    }
}