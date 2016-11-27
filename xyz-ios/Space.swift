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
    var id: String
    var firstSong: Item?
    var playlist: [Item]?
    
    let Playlister = PlaylisterSingleton.sharedInstance
    
    init(params: [String:String], items: [Item]){
        self.name = params["name"]!
        self.id = params["id"]!
        self.items = items
        
        if let firstSongId = params["firstSong"]{
            var found = false
            for item in items{
                if (!found && item.id == firstSongId){
                    self.firstSong = item
                    found = true
                }
            }
        }
        
        Playlister.upsert(fromSpace: self)
        
        print("initialized Space with name \(self.name). playlist is...")
        Playlister.get(forSpace:self)!.describe()
        
    }
    
    func attachItemDelegatesTo(player: Player){
        
        for item in self.items {
            item.delegate = player
        }
        
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
