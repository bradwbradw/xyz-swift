//
//  Space.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

class Space {
    
    var name: String
    var items: [Item]
    
    init(params: [String:String], items: [Item]){
        self.name = params["name"]!
        self.items = items
        print("initialized Space with name \(self.name)")
    }
    
    subscript(name: String) -> String {
        
        get {
            return self.name;
        }
        set {
            self.name = newValue
        }
        
    }
    
    subscript(items: String) -> [Item] {
        
        get {
            return self.items
        }
        set {
            self.items = newValue
        }
    }
    
    
}
