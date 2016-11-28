//
//  Item.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import SpriteKit

class Item: SKShapeNode, ServerSignals {
    
    var id : String
    var title: String
    var x: Int // using same coord system as xyz.gs
    var y: Int // using same coord system as xyz.gs
    var imageUrl: String
    //    var artist: String
    var provider: String
    var provider_id: String
    
    var imageSprite: SKSpriteNode
    let DOT_RADIUS = 12
    
    var dateSaved: Date?
    
    let server = Server()
    
    var elementToActivateWhenSelected: ItemDetailView?
    
    var delegate: ServerSignals?
    
    init(params: [String: String], position: (Int, Int)){
        self.title = params["title"]!
        self.provider = params["provider"]!
        self.provider_id = params["provider_id"]!
        self.id = params["id"]!
        self.imageUrl = params["pic"]!
        self.x = position.0
        self.y = position.1
//        let texture = SKTexture(imageNamed: "xyz-square")
        
        imageSprite = SKSpriteNode(texture: nil, color:#colorLiteral(red: 1, green: 0.4410438538, blue: 0.9856794477, alpha: 1) ,size: CGSize(width:40, height:40))
        super.init()
        self.path = UIBezierPath(ovalIn: CGRect(x:-DOT_RADIUS, y:-DOT_RADIUS, width:2*DOT_RADIUS, height:2*DOT_RADIUS)).cgPath
        self.fillColor = UIColor.white
//        self.strokeColor = #colorLiteral(red: 0.8134505153, green: 0.9867565036, blue: 0.9832226634, alpha: 1)
//        self.lineWidth = 5
        self.position = CGPoint(x:self.x, y: SPACE_DIMENSIONS.height - self.y)
        self.zPosition = 1
        self.isUserInteractionEnabled = true

        
        
        self.addChild(imageSprite)
        
        server.delegate = self
        server.loadImage(url: self.imageUrl)
//        print("creating new item: \(self.title) with x \(self.x) and y \(self.y)")
    }
    
    convenience init(fromJson: [String: AnyObject]){
        var rawItem = fromJson
        let initParams: [String: String] =
            ["title": rawItem["title"] as! String,
             "provider": rawItem["provider"] as! String,
             "provider_id": rawItem["provider_id"] as! String,
             "pic": rawItem["pic"] as! String,
             "id": rawItem["id"] as! String]
        let point = (rawItem["x"] as! Int, rawItem["y"] as! Int)
        
        self.init(params: initParams, position: point)

    }
    
    func didLoad(image: UIImage?) {
        print("got the signal: \(self.title)")
        if let img = image{
            imageSprite.texture = SKTexture(image:img)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {        elementToActivateWhenSelected!.update(withItem: self)
    }
    
    func distanceTo(item: Item) -> CGFloat{
        let dx = self.x - item.x
        let dy = self.y - item.y
        let sum = (dx * dx) + (dy * dy)
        return sqrt(CGFloat(sum));

    }

    static func ==(first: Item, second: Item) -> Bool {
        return first.id == second.id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

