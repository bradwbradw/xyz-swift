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
    var haloNode: SKShapeNode
    
    let regularDotPath: CGPath
    let selectedDotPath: CGPath
    var minScaleSoFar: CGFloat
    var maxScaleSoFar: CGFloat
    
    //    let background = SKSpriteNode(color: .black, size: CGSize.zero)
    
    init(space activeSpace:Space, player:Player) {
        
        minScaleSoFar = 1.0
        maxScaleSoFar = 1.0
        itemDetailView = ItemDetailView()
        
        space = activeSpace
        items = space["items"] as [Item]!;
        
        regularDotPath = UIBezierPath(ovalIn: CGRect(x:-DOT_ATTRIBUTES.radius, y:-DOT_ATTRIBUTES.radius, width:2*DOT_ATTRIBUTES.radius, height:2*DOT_ATTRIBUTES.radius)).cgPath
        selectedDotPath = UIBezierPath(ovalIn: CGRect(x:-DOT_ATTRIBUTES.radiusBig, y:-DOT_ATTRIBUTES.radiusBig, width:2*DOT_ATTRIBUTES.radiusBig, height:2*DOT_ATTRIBUTES.radiusBig)).cgPath
        haloNode = SKShapeNode()
        haloNode.path = regularDotPath
        haloNode.glowWidth = 15
        haloNode.strokeColor = UIColor.white
        haloNode.isHidden=true
        
        super.init(size:CGSize(width: SPACE_DIMENSIONS.width,
                               height: SPACE_DIMENSIONS.height))
        print("init scene with size...")
        print(size)
        
        //        self.background.name = "background"
        //        self.background.anchorPoint = CGPoint(x: 0, y: 0)
        //        self.background.size = size
        // 2
        //        self.addChild(background)
        self.addChild(haloNode)
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
        itemDetailView.isHidden = true
        
        for item in items {
            item.detailView = itemDetailView
            self.addChild(item)
        }
        self.addChild(itemDetailView)
        
        
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: scene!.size.width / 2, y:scene!.size.height / 2)
        self.addChild(cameraNode)
        self.camera = cameraNode
        itemDetailView.sceneCamera = self.camera
        
        self.scaleMode = SKSceneScaleMode.resizeFill
        
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
        let newX = (camera!.position.x - translation.x*camera!.xScale)
        let newY = (camera!.position.y + translation.y*camera!.xScale)
        camera!.position = keepInsideBoundaries(point: CGPoint(x: newX, y: newY))
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func handlePinch(recognizer: UIPinchGestureRecognizer){
        let targetZoom = camera!.xScale / recognizer.scale
        camera!.xScale = targetZoom
        camera!.yScale = targetZoom
        recognizer.scale = 1.0//(CGPoint.zero, in: self.view)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        space.deselectAllItems()
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
        shapeNode.lineWidth = 0.25
        shapeNode.strokeColor = .white
        return shapeNode
    }
    
    func updatePlayingHalo(newPlayingItem: Item){
        haloNode.isHidden = false
        haloNode.position = newPlayingItem.position
        if(newPlayingItem.state.selected[1]){
            haloNode.path = selectedDotPath
        } else {
            haloNode.path = regularDotPath
        }
    }
    
    func changed(state: String, for item: Item ) -> Bool {
        return item.state[state][0]  != item.state[state][1]
    }
    
    func applySelectedStyle(to item: Item){
        item.path = selectedDotPath
        item.zPosition = 2
        if(item.state.playing[1]){
            updatePlayingHalo(newPlayingItem: item)
        }
    }
    
    func removeSelectedStyle(to item: Item){
        item.path = regularDotPath
        
        if(item.state.playing[1]){
            updatePlayingHalo(newPlayingItem: item)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        for item in items {
            
            if item.state.playing[1] && changed(state: "playing", for: item){
                updatePlayingHalo(newPlayingItem: item)
                item.state.playing[0] = true
            }
            
            if !item.state.playing[1] && changed(state: "playing",for: item){
                item.state.playing[0] = false
            }
            
            if item.state.selected[1] && changed(state: "selected",for: item ){
                applySelectedStyle(to:item)
                item.state.selected[0] = true
            }
            
            if !item.state.selected[1] && changed(state: "selected", for: item ){
                removeSelectedStyle(to:item)
                item.state.selected[0] = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
