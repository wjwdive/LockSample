//
//  Greeting.swift
//  LockSample
//
//  Created by wjw on 2025/12/11.
//

import Foundation

@objc class Greeting: NSObject {
    @objc var name: String
    
    @objc init(name: String) {
        self.name = name
    }
    
    @objc func greet() {
        print("greeting use Swift class and function: Hello, \(name)!")
    }

}
