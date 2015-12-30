import Foundation
import FBSDKLoginKit

public class DataController{
    private static var dataManager:DataController?
    private static var lockObject = NSLock()
    public var dataSource:DataProtocol?
    
    public static func shareInstance() -> DataController {
        
        // prevent race condition
        lockObject.lock()
        if dataManager == nil {
            dataManager = DataController()
        }
        lockObject.unlock()
        return dataManager!
    }
    
    func login() {
        LoginRequest.execute(){ response in
            dispatch_async(dispatch_get_main_queue()) {
                switch response {
                case let .Success(data):
                    self.dataSource?.loginSuccess(data)
                case let .Error(error):
                    self.dataSource?.fetchedDataFail(.ToDo, error: error)
                }
            }
        }
    }
    
    func addTodoItem(title:String, detail:String){
        TodoRequest.addTodoItem(title,detail: detail){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                if response {
                    DataController.shareInstance().getTodoList()
                } else {
                    
                }
            }
        }
    }
    
    func editTodoItem(objid:String, title:String, detail:String, haveDone:Bool){
        TodoRequest.changeTodoItem(objid, title: title,detail: detail,haveDone: haveDone){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                if response {
                    if haveDone {
                        DataController.shareInstance().getHaveDoneList()
                    } else {
                        DataController.shareInstance().getTodoList()
                    }
                } else {
                    
                }
            }
        }
    }
    
    func getTodoList(){
        TodoRequest.fetchList(){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                    switch response {
                    case let .Success(data):
                        self.dataSource?.fetchedToDo(data)
                    case let .Error(error):
                        self.dataSource?.fetchedDataFail(.ToDo, error: error)
                }
            }
        }
    }
    
    func deleteTodoItem(objId:String){
        TodoRequest.deleteItem(objId){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                if response {
                    
                } else {
                    
                }
            }
        }
    }
    
    func getHaveDoneList(){
        HaveDoneRequest.fetchList(){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                switch response {
                case let .Success(data):
                    self.dataSource?.fetchedHaveDone(data)
                case let .Error(error):
                    self.dataSource?.fetchedDataFail(.ToDo, error: error)
                }
            }
        }
    }
    
    func deleteHaveDoneItem(objId:String){
        HaveDoneRequest.deleteItem(objId){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                if response {
                    
                } else {
                    
                }
            }
        }
    }
    
    func finishTodoItem(objId:String){
        TodoRequest.moveToHaveDone(objId){
            response in
            dispatch_async(dispatch_get_main_queue()) {
                if response {
                    self.dataSource?.finishTodoItem()
                } else {
                    
                }
            }
        }
    }
}
