import Foundation

extension NSObject{
    
    /**
     clear log
     
     - parameter message: any type message description
     - parameter file:    from which file
     - parameter method:  from which method
     - parameter line:    log at which line
     */
    func Log<T>(message: T,
        file: String = __FILE__,
        method: String = __FUNCTION__,
        line: Int = __LINE__)
    {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    }
    
    /**
     static log
     
     - parameter message:
     - parameter file:
     - parameter method:
     - parameter line:    
     */
    static func Log<T>(message: T,
        file: String = __FILE__,
        method: String = __FUNCTION__,
        line: Int = __LINE__)
    {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    }
}
