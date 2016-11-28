//
//  Space.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

class Space {
    
    var name: String
    var items: [Item]?
    var id: String
    var firstSong: Item?
    var playlist: [Item]?
    
    let Playlister = PlaylisterSingleton.sharedInstance
    
    init(params: [String:String]){
        
        self.name = params["name"]!
        self.id = params["id"]!
        
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
        
        self.init(params: spaceParams)
        
        let rawItems = json["songs"] as! [ [String: AnyObject] ]
        var items: [Item] = []
        for rawItem in rawItems {
            items.append( Item(fromJson:rawItem, space:self) )
        }
        
        self.items = items
        
        if let firstSongId = spaceParams["firstSong"]{
            var found = false
            for item in items{
                if (!found && item.id == firstSongId){
                    self.firstSong = item
                    found = true
                }
            }
        }
        
        Playlister.upsert(fromSpace: self)

    }
    
    func deselectAllItems(){
        for item in items!{
            item.deselect()
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
            return self.items!
        }
        set {
            self.items = newValue
        }
    }
    
}
