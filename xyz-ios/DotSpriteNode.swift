//
//  DotSpriteNode.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/15/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import SpriteKit

class DotSpriteNode : SKSpriteNode

{
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches end")
        print(event ?? "??")
        print(touches )
    }
}
