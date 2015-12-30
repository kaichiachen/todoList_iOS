import Foundation

public protocol DataProtocol {
    func loginSuccess(data:NSDictionary)
    func fetchedHaveDone(data:[TodoData])
    func fetchedToDo(data:[TodoData])
    func finishTodoItem()
    func fetchedDataFail(type:DataType,error:String)
}