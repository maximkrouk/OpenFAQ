//
//  HomeController.swift
//  App
//
//  Created by Maxim Krouk on 1/28/20.
//

import Fluent
import Vapor

final class HomeController {
    
    func routes(_ app: Application) throws {
        app.get { req in "It works!" }
        app.get("hello") { req in "Hello, world!" }
    }
    
}
