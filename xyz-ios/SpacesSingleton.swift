//
//  SpacesSingleton.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/26/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import Foundation

class SpacesSingleton {

    static let sharedInstance = SpacesSingleton()
    
    var viewing: Space?
    var playing: Space?
    
    var map: [String: Space] = [:]
    
    private init(){
        print("creating Spaces singleton")
    }
    
    func upsert(space: Space){
        self.map[space.id] = space
        print("upserted space \(space.id). Now map looks like...")
        print(map)
    }
    
}
