//
//  SpaceViewDotScene.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import SpriteKit

class SpaceViewDotScene: SKScene {
    
    var space:Space
    var items:[Item]
    
    init(size:CGSize, scaleMode:SKSceneScaleMode, space:Space) {
        self.space = space
        self.items = space["items"] as [Item]!;
        super.init(size:size)
        self.scaleMode = scaleMode
        
        for item in items {
            self.addChild(item)
        }
        
        let helloNode:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        helloNode.text = space.name;
        helloNode.fontSize = 42;
        helloNode.position = CGPoint(x:size.width/2, y:size.height * 6/7)
        
        //CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        self.addChild(helloNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
