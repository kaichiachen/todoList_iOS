
import Foundation

public class DataCache {
    
    lazy var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    static var dataCache:DataCache?
    
    static func shareInstance() -> DataCache{
        if dataCache == nil {
            dataCache = DataCache()
        }
        return dataCache!
    }
    
    /**
     standard request parameter
     
     - returns: standard request parameter
     */
    public func getRequestParameter() -> NSDictionary? {
        let data = getUserData()
        if data.3 == false || data.2 == nil {
            return nil
        }
        var request = [String:String]()
        request["uid"] = data.0
        request["token"] = data.1
        return request
    }
    
    public func setUserToken(token:String) {
        userDefaults.setObject(token ?? "",forKey:"UserToken")
        userDefaults.synchronize()
    }
    
    public func getUserToken() -> String {
        
        let token = userDefaults.objectForKey("UserToken") as? String
        return token ?? ""
    }
    
    /**
     set user data
     
     - parameter id:       s + student id
     - parameter password: portal password
     - parameter token:    request token
     */
    public func setUserData(id:String, password:String, token:String, login:Bool = true) {
        userDefaults.setObject(id,forKey:"UserId")
        userDefaults.setObject(password,forKey:"UserPassword")
        userDefaults.setObject(token ?? "",forKey:"UserToken")
        userDefaults.setObject(login,forKey:"UserLogin")
        userDefaults.synchronize()
    }
    
    /**
     get user foundation data
     
     - returns: user foundation data
     */
    public func getUserData() -> (String?,String?,String?,Bool) {
        let username = userDefaults.objectForKey("UserId") as? String
        let password = userDefaults.objectForKey("UserPassword") as? String
        let token = userDefaults.objectForKey("UserToken") as? String
        let login = userDefaults.objectForKey("UserLogin") as? Bool
        return (username, password, token, login ?? false)
    }
    
    public func setUserPersonalInfo(name:String, dep:String){
        userDefaults.setObject(name,forKey:"UserName")
        userDefaults.setObject(dep,forKey:"UserDep")
        userDefaults.synchronize()
    }
    
    public func getUserPersonalInfo() -> (String,String) {
        let name = userDefaults.objectForKey("UserName") as? String ?? ""
        let dep = userDefaults.objectForKey("UserDep") as? String ?? ""
        return (name,dep)
    }
    
    
    
    
    
}