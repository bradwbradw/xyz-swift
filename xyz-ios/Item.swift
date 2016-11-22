//
//  Item.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import SpriteKit

class Item: SKSpriteNode {
    //    var id: String
    var id : String
    var title: String
    var x: Int
    var y: Int
    //    var artist: String
    var provider: String
    var provider_id: String
    
    var delegate: MediaMethods?
    
    init(params: [String: String], position: (Int, Int)){
        self.title = params["title"]!
        self.provider = params["provider"]!
        self.provider_id = params["provider_id"]!
        self.id = params["id"]!
        self.x = position.0
        self.y = position.1
        let texture = SKTexture(imageNamed: "xyz-square")
        super.init(texture: texture, color: UIColor(), size: texture.size())
        
        self.position = CGPoint(x:position.0, y: position.1)
        self.isUserInteractionEnabled = true
        
//        print("creating new item: \(self.title) with x \(self.x) and y \(self.y)")
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.play(item: self)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

