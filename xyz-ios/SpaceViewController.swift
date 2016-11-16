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

    @IBOutlet weak var mediaViewer: UIView!
    
    
   
    func playItem(notification : Notification){
        if let mediaInfo = notification.userInfo?["mediaInfo"] as? String {
            print("i have event and i have mediaViewer outlet!")
            print(mediaInfo)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("i got a space: ")
        print(space?["name"] as String!)
    
//        let scene = HomeScene(size:screenSize, scaleMode:SKSceneScaleMode.AspectFill, viewController: self)

        let scene = DotViewScene(size: view.bounds.size, scaleMode:SKSceneScaleMode.aspectFill, space: space!)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playItem), name: Notification.Name("playItem"), object: nil)

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

