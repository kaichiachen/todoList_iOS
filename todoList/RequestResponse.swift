//
//  RequestResponse.swift
//  todoList
//
//  Created by Andy Chen on 12/26/15.
//  Copyright © 2015 Andy chen. All rights reserved.
//

import Foundation

public enum RequestResponse<T> {
    case Success(T)
    case Error(String)
}