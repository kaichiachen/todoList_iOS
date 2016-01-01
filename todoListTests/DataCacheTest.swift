//
//  todoListTests.swift
//  todoListTests
//
//  Created by Andy Chen on 12/31/15.
//  Copyright © 2015 Andy chen. All rights reserved.
//

import Quick
import Nimble
@testable import todoList

class DataCacheTest: QuickSpec {
    
    override func spec() {
        
        describe("init"){
            it("check login data"){
                DataCache.shareInstance().logout()

                var loginData = DataCache.shareInstance().getUserLoginData()
                expect(loginData).to(equal(""))
                expect(DataCache.shareInstance().isLogin()).to(equal(false))
                
                let userLoginId = "10232022312"
                DataCache.shareInstance().setUserLoginData(userLoginId)
                loginData = DataCache.shareInstance().getUserLoginData()
                expect(loginData).to(equal(userLoginId))
                expect(DataCache.shareInstance().isLogin()).to(equal(true))
                
                DataCache.shareInstance().logout()
                
                loginData = DataCache.shareInstance().getUserLoginData()
                expect(loginData).to(equal(""))
                expect(DataCache.shareInstance().isLogin()).to(equal(false))
                
                DataCache.shareInstance().logout()
            }
            it("check user personal info"){
                DataCache.shareInstance().logout()
                
                var userPersonalData = DataCache.shareInstance().getUserPersonalInfo()
                expect(userPersonalData.0).to(equal(""))
                expect(userPersonalData.1).to(equal(NSData()))
                
                let userData = ("Andy Chen", NSData(base64EncodedString: "test test", options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters))
                DataCache.shareInstance().setUserPersonalInfo(userData.0, userPicture: userData.1!)
                userPersonalData = DataCache.shareInstance().getUserPersonalInfo()
                expect(userPersonalData.0).to(equal(userData.0))
                expect(userPersonalData.1).to(equal(userData.1))
                
                DataCache.shareInstance().logout()
                
                userPersonalData = DataCache.shareInstance().getUserPersonalInfo()
                expect(userPersonalData.0).to(equal(""))
                expect(userPersonalData.1).to(equal(NSData()))
                
                DataCache.shareInstance().logout()
            }
        }
    }
    
}
