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

class SpaceViewController: UIViewController, YTPlayerViewDelegate {
    
    let Spaces = SpacesSingleton.sharedInstance
    var space: Space?
    var activeItem: Item?
    var scene: SpaceViewDotScene?
    
    @IBOutlet weak var ytPlayer: YTPlayerView!
    
    @IBOutlet weak var scPlayer: UIView!
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
        
        let player = Player(label: itemNameLabel, ytView: ytPlayer, scView: scPlayer )
        
        self.space = Spaces.viewing!

        ytPlayer.delegate = self
        self.title = space!.name
        
        self.scene = SpaceViewDotScene(space: space!, player: player)
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(self.scene)
        
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch(state) {
        case YTPlayerState.playing:
            print("youtube started playback")
            break
        case YTPlayerState.paused:
            print("youtube paused playback")
            break
        case YTPlayerState.ended:
            print("youtube ended playback")
//            player.didFinishPlaying(<#T##Player#>)
            break
        default:
            break
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print("youtube player is ready")
        ytPlayer.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print("youtube player error...")
        print(error)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer){
        if let scene = self.scene{
            scene.handlePan(recognizer: recognizer)
        }
    }
    @IBAction func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if let scene = self.scene{
            scene.handlePinch(recognizer: recognizer)
        }
    }

}

