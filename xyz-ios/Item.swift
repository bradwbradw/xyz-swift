//
//  Item.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import SpriteKit

class Item: SKShapeNode {
    //    var id: String
    var id : String
    var title: String
    var x: Int // using same coord system as xyz.gs
    var y: Int // using same coord system as xyz.gs
    //    var artist: String
    var provider: String
    var provider_id: String
    
    var dateSaved: Date?
    
    var elementToActivateWhenSelected: ItemDetailView?
    
    var delegate: MediaMethods?
    
    init(params: [String: String], position: (Int, Int)){
        self.title = params["title"]!
        self.provider = params["provider"]!
        self.provider_id = params["provider_id"]!
        self.id = params["id"]!
        self.x = position.0
        self.y = position.1
//        let texture = SKTexture(imageNamed: "xyz-square")
        
        super.init()
        self.path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:30, height:30)).cgPath
        self.fillColor = UIColor.white
        self.strokeColor = #colorLiteral(red: 0.8134505153, green: 0.9867565036, blue: 0.9832226634, alpha: 1)
        self.lineWidth = 5
        
        self.position = CGPoint(x:self.x, y: SPACE_DIMENSIONS.height - self.y)
        self.isUserInteractionEnabled = true
        
//        print("creating new item: \(self.title) with x \(self.x) and y \(self.y)")
    }
    
    convenience init(fromJson: [String: AnyObject]){
        var rawItem = fromJson
        let initParams: [String: String] =
            ["title": rawItem["title"] as! String,
             "provider": rawItem["provider"] as! String,
             "provider_id": rawItem["provider_id"] as! String,
             "id": rawItem["id"] as! String]
        let point = (rawItem["x"] as! Int, rawItem["y"] as! Int)
        
        self.init(params: initParams, position: point)

    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        elementToActivateWhenSelected!.update(withItem: self)
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

