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
        
//        print("initialized Space with name \(self.name). playlist is...")
//        Playlister.get(forSpace:self)!.describe()
        
    }
    
    convenience init(fromJson: [String: AnyObject]){
        let json = fromJson
        let spaceParams: [String: String] = [
            "name": json["name"] as! String,
            "id":json["id"] as! String,
            "firstSong":json["firstSong"] as! String
        ]
        
        let items = json["songs"] as! [ [String: AnyObject] ]
        var cleanItems: [Item] = []
        for rawItem in items {
            cleanItems.append( Item(fromJson:rawItem) )
        }
        self.init(params: spaceParams, items: cleanItems)
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
