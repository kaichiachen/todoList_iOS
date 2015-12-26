
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
    
    public func setUserLoginData(id:String,token:String) {
        userDefaults.setObject(token ?? "",forKey:"UserToken")
        userDefaults.setObject(id ?? "",forKey:"UserId")
        userDefaults.setObject(true ?? "",forKey:"UserLogin")
        userDefaults.synchronize()
    }
    
    public func getUserLoginData() -> (String,String) {
        
        let token = userDefaults.objectForKey("UserToken") as? String
        let id = userDefaults.objectForKey("UserId") as? String
        return (id ?? "", token ?? "")
    }
    
    public func isLogin() -> Bool {
        return userDefaults.objectForKey("UserLogin") as? Bool ?? false
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