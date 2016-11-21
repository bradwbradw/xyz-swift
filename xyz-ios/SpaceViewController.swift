//
//  DotView.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import UIKit
import SpriteKit
class SpaceViewController: UIViewController {
    
    var space: Space?
    var activeItem: Item?

    @IBOutlet weak var mediaPlayerView: UIView!
    
    @IBOutlet weak var mediaPlayer2: UIView!
    
    @IBOutlet weak var nameLabel2: UILabel!
    
    func setActive(item: Item?){
        guard let newItem = item else {
            print("no item found in setActive");
            return;
        }
        print("setting new active item:")
        print(newItem)
        self.activeItem = newItem
    }
    
    // TODO
    // make viewdidload add a new player() object ref
    //
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("i got a space: ")
        print(space?["name"] as String!)
        
        let player = Player(label: nameLabel2)
        
        space?.setUpPlayer(player: player)
        
        let scene = SpaceViewDotScene(size: view.bounds.size, scaleMode:SKSceneScaleMode.aspectFill, space: space!)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

