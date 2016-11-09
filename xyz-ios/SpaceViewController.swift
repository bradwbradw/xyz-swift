//
//  DotView.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import UIKit
import SpriteKit
class SpaceViewController: UIViewController{
    
    var space: Space?

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = DotViewScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        
        print("i got a space: ")
        print(space?["name"] as String!)
    
        let songs = space?["items"] as [Item]!;
        
        print(songs ?? "trying to print songs");
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

