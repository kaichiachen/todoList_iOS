
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
     save fb id for parse user id
     
     - parameter id: fb id
     */
    public func setUserLoginData(id:String) {
        userDefaults.setObject(id ?? "",forKey:"UserId")
        userDefaults.setObject(true,forKey:"UserLogin")
        userDefaults.synchronize()
    }
    
    public func getUserLoginData() -> String {
        
        let id = userDefaults.objectForKey("UserId") as? String
        return id ?? ""
    }
    
    public func isLogin() -> Bool {
        return userDefaults.objectForKey("UserLogin") as? Bool ?? false
    }
    
    public func setUserPersonalInfo(name:String, userPicture:NSData){
        userDefaults.setObject(name,forKey:"UserName")
        userDefaults.setObject(userPicture, forKey: "UserPicture")
        userDefaults.synchronize()
    }
    
    public func getUserPersonalInfo() -> (String,NSData) {
        let name = userDefaults.objectForKey("UserName") as? String ?? ""
        let userPicture = userDefaults.objectForKey("UserPicture") as? NSData ?? NSData()
        return (name,userPicture)
    }
    
    /**
     clear all cache
     */
    public func logout(){
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }
    }
}