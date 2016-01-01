//
//  todoListTests.swift
//  todoListTests
//
//  Created by Andy Chen on 12/30/15.
//  Copyright © 2015 Andy chen. All rights reserved.
//

import Quick
import Nimble
@testable import todoList

class TodoDataSpec: QuickSpec {
    
    override func spec() {
        
        describe("init"){
            it("should init with TodoData correctly"){
                let todoData = TodoData(detail: "a hard homework",title: "do homework",itemId: "0bf67de")
                expect(todoData.title).to(equal("do homework"))
                expect(todoData.detail).to(equal("a hard homework"))
                expect(todoData.havedone).to(equal(false))
                let duplicate = todoData.copy() as! TodoData
                duplicate.title = "buy dinner"
                expect(todoData.title).notTo(equal(duplicate.title))
            }
            it("should init with HaveDoneData correctly"){
                let haveDoneData = TodoData(detail: "a hard homework",title: "do homework",itemId: "0bf67de",haveDone: true)
                expect(haveDoneData.title).to(equal("do homework"))
                expect(haveDoneData.detail).to(equal("a hard homework"))
                expect(haveDoneData.havedone).to(equal(false))
                let duplicate = haveDoneData.copy() as! TodoData
                duplicate.title = "buy dinner"
                expect(haveDoneData.title).notTo(equal(duplicate.title))
            }
        }
    }
    
}
