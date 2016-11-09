//
//  Space.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

class Space {
    
    //    var id: String
    var name: String
    var items: [Item]
    
    init(name: String){
        self.name = name
        self.items = []
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
