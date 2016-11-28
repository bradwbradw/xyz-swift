//
//  ItemDetailView.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/28/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import Foundation
import SpriteKit


class ItemDetailView: SKNode{
    
    
    var item: Item?
    var delegate: MediaMethods?
    let itemName: SKLabelNode
    let playButton: SKLabelNode
    let background: SKSpriteNode
    
    override init(){
        
        itemName = SKLabelNode(fontNamed: "Helvetica")
        playButton = SKLabelNode(fontNamed: "Helvetica")
        background = SKSpriteNode(texture: nil, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6012577571), size: CGSize(width:60, height:20))
        itemName.text = "XYZ ITEM\n /n "
        itemName.fontColor = #colorLiteral(red: 1, green: 0.4410438538, blue: 0.9856794477, alpha: 1)
        itemName.fontSize = 15
        itemName.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        playButton.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
        playButton.text = "▶"
        
        super.init()
        
        self.zPosition = 2
        self.addChild(background)
        self.addChild(itemName)
        self.addChild(playButton)
        
        self.isUserInteractionEnabled = true
        
    }
    
    func updateBackground(){
        background.size.height = playButton.frame.size.height + itemName.frame.size.height
        background.size.width = itemName.frame.size.width
        background.position = CGPoint(x:0,y:0)
    }
    
    func update(withItem: Item){
        
        item = withItem
        
        self.position = item!.position
        self.position.y =  self.position.y + 30
        
        self.isHidden = false
        self.itemName.text = item!.title
        print(" item name size is \(itemName.frame.size.width)")
        updateBackground()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touching item detail view")
        var touchedPlayButton = false
        for touch in touches{
            
            let touchLocation = touch.location(in: self)
            
            if( playButton.contains(touchLocation)){
                touchedPlayButton = true
            }
            
            if(touchedPlayButton){
                
                print("play that ish")
                touchPlay()
            } else {
                print("did not touch play but touched item detail view")
            }
            
        }
    }
    
    
    func touchPlay(){
        delegate?.play(item: self.item!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
