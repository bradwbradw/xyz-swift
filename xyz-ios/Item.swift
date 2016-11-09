//
//  Item.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//


class Item {
    //    var id: String
    var title: String
    var position: (Int, Int)
    //    var artist: String
    //    var provider: String
    //    var provider_id: String
    
    
    init(params: [String: String], position: (Int, Int)){
        self.title = params["title"]!
        self.position = position
        
        print("creating new item: \(self.title) with x \(self.position.0) and y \(self.position.1)")
    }
    
}

