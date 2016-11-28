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
    let Playlister = PlaylisterSingleton.sharedInstance
    var itemDetailView: ItemDetailView
    
    let background = SKSpriteNode(color: .black, size: CGSize.zero)
    
    init(space:Space, player:Player) {
        
        itemDetailView = ItemDetailView()
        
        self.space = space
        self.items = space["items"] as [Item]!;
        super.init(size:CGSize(width: SPACE_DIMENSIONS.width,
                               height: SPACE_DIMENSIONS.height))
        print("init scene with size...")
        print(size)
     
        self.background.name = "background"
        self.background.anchorPoint = CGPoint(x: 0, y: 0)
        self.background.size = size
        // 2
        self.addChild(background)
//      // FOR iOS version < 9 ( does not support SKCameraNode() )
//        self.anchorPoint = CGPoint(x:0.5,y:0.5);
//        let anchorLabel = SKLabelNode(fontNamed: "Arial")
//        anchorLabel.text = "anchor"
//        anchorLabel.position = self.anchorPoint
//        self.addChild(anchorLabel)
//        
//        let scrollingWorldNode = SKNode()
//        self.addChild(scrollingWorldNode)
//        
//        let camera = SKNode()
//        camera.name = "camera"
//        scrollingWorldNode.addChild(camera)
//        
//
//        
        
        self.addChild(generatePlaylistShapeNode())
        
        itemDetailView.delegate = player
        itemDetailView.position = CGPoint(x: 0, y: 0)
        
        for item in items {
            item.elementToActivateWhenSelected = itemDetailView
            self.addChild(item)
        }
        self.addChild(itemDetailView)
        
        
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: scene!.size.width / 2, y:scene!.size.height / 2)
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        let helloNode:SKLabelNode = SKLabelNode(fontNamed: "Helvetica")
        helloNode.text = space.name;
        helloNode.fontSize = 42;
        helloNode.position = CGPoint(x:size.width/2, y:size.height * 6/7)
        
//        let zoomInAction = SKAction.scale(to: 0.5, duration: 1)
//        _ = SKAction.scale(to: 0.5, duration: 1)
//        cameraNode.run(zoomInAction)
//        
        self.addChild(helloNode)
        
        self.scaleMode = SKSceneScaleMode.fill
        
    }
    
    func keepInsideBoundaries(point: CGPoint) -> CGPoint{
        
        var x = point.x
        var y = point.y
        
        if (x > self.size.width){
            x = self.size.width
        }
        if (x < 0){
            x = 0
        }
        
        if (y > self.size.height){
            y = self.size.height
        }
        if(y < 0){
            y = 0
        }
        
        return CGPoint(x: x, y: y)

    }
    func handlePan(recognizer: UIPanGestureRecognizer){
        
        let translation = recognizer.translation(in: self.view)
        if let camera = self.camera{
            let newX = camera.position.x - translation.x
            let newY = camera.position.y + translation.y
            
            camera.position = keepInsideBoundaries(point: CGPoint(x: newX, y: newY))
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        itemDetailView.isHidden = true
        print("touching view")
    }
    
//    
//    override func didFinishUpdate() {
//        if let cameraNode = self.childNode(withName: "camera"){
//            centerOnNode(node: cameraNode)
//        } else {
//            print("cannot find camera node")
//        }
//    }
//    
//    func centerOnNode(node:SKNode)
//    {
//        let cameraPositionInScene: CGPoint = convert(node.position, from: node.parent!)
//        node.parent?.position = CGPoint(x: (node.parent?.position.x)! - cameraPositionInScene.x, y:(node.parent?.position.y)! - cameraPositionInScene.y);
//        print("camera position... ")
//        print(cameraPositionInScene)
//        print("node parent position ...")
//        print(node.parent?.position as Any)
//    }
    
    
    func generatePlaylistShapeNode() -> SKShapeNode{
        let playlist = Playlister.get(forSpace: self.space)!.entries
        let pointer: UnsafeMutablePointer<CGPoint> = UnsafeMutablePointer(mutating: Playlister.getPoints(forSpace: self.space))
        let shapeNode = SKShapeNode(points: pointer, count: (playlist?.count)!)
        shapeNode.lineWidth = 2.0
        shapeNode.strokeColor = .white
        return shapeNode
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
