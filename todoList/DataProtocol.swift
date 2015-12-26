import Foundation

public protocol DataProtocol {
    func fetchedHaveDone(data:[TodoData])
    func fetchedToDo(data:[TodoData])
    func fetchedDataFail(type:DataType,error:String)
}