//
//  DotView.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import UIKit
import SpriteKit
import youtube_ios_player_helper

class SpaceViewController: UIViewController {
    
    var space: Space?
    var activeItem: Item?
    
    @IBOutlet weak var ytPlayer: YTPlayerView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    func setActive(item: Item?){
        guard let newItem = item else {
            print("no item found in setActive");
            return;
        }
        print("setting new active item:")
        print(newItem)
        self.activeItem = newItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let player = Player(label: itemNameLabel, ytView: ytPlayer)
        
        space?.attachItemDelegatesTo(player: player)
        
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

