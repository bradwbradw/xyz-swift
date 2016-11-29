//
//  Item.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/8/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import SpriteKit

struct itemState {

    var playing: [Bool] = [false, false] // index 0 is last frame state, 1 is current frame state
    var selected: [Bool] = [false, false]
    
    
    subscript(prop: String) -> [Bool] {
        get {
            if(prop == "playing")  {
             return self.playing
            }
            if(prop == "selected")  {
             return self.selected
            }
            return [false, false]
        }
        set {
            if(prop == "playing")  {
                self.playing = newValue
            }
            if(prop == "selected")  {
                self.selected = newValue
            }
            
        }
        
    }
    
    
}
class Item: SKShapeNode, ServerSignals {
    
    var id : String
    var title: String
    //    var artist: String
    var x: Int // using same coord system as xyz.gs
    var y: Int // using same coord system as xyz.gs
    var imageUrl: String
    var provider: String
    var provider_id: String
    var parentSpace: Space?
    var state = itemState( playing: [false, false], selected: [false, false])
    
    var dateSaved: Date?
    
    let server = Server()
    var delegate: ServerSignals?
    var detailView: ItemDetailView? // one view, common to all items
    
    init(params: [String: String], position: (Int, Int), space: Space){
        self.title = params["title"]!
        self.provider = params["provider"]!
        self.provider_id = params["provider_id"]!
        self.id = params["id"]!
        self.imageUrl = params["pic"]!
        self.x = position.0
        self.y = position.1
        self.parentSpace = space
//        let texture = SKTexture(imageNamed: "xyz-square")
        
        super.init()
        self.path = UIBezierPath(ovalIn: CGRect(x:-DOT_ATTRIBUTES.radius, y:-DOT_ATTRIBUTES.radius, width:2*DOT_ATTRIBUTES.radius, height:2*DOT_ATTRIBUTES.radius)).cgPath
        self.fillColor = UIColor.white
//        self.strokeColor = #colorLiteral(red: 0.8134505153, green: 0.9867565036, blue: 0.9832226634, alpha: 1)
        self.lineWidth = 0
        self.position = CGPoint(x:self.x, y: SPACE_DIMENSIONS.height - self.y)
        self.zPosition = 1
        self.isUserInteractionEnabled = true
        server.delegate = self
        server.loadImage(url: self.imageUrl)
//        print("creating new item: \(self.title) with x \(self.x) and y \(self.y)")
    }
    
    convenience init(fromJson: [String: AnyObject], space: Space){
        var rawItem = fromJson
        let initParams: [String: String] =
            ["title": rawItem["title"] as! String,
             "provider": rawItem["provider"] as! String,
             "provider_id": rawItem["provider_id"] as! String,
             "pic": rawItem["pic"] as! String,
             "id": rawItem["id"] as! String]
        let point = (rawItem["x"] as! Int, rawItem["y"] as! Int)
        
        self.init(params: initParams, position: point, space: space)

    }
    
    func didLoad(image: UIImage?) {
        if let img = image{
            self.fillTexture = SKTexture(image:img)
        }
    }
    func select(){
        self.state.selected[1] = true
        detailView!.update(withItem: self)
    }
    func deselect(){
        self.state.selected[1] = false
    }
    func setPlaying(){
        self.state.playing[1] = true
    }
    func unsetPlaying(){
        self.state.playing[1] = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        parentSpace!.deselectAllItems()
        select()
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

