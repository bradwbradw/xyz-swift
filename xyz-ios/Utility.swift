//
//  Utility.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/27/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import SpriteKit
import Foundation

class Utility {

    
    class func objToJsonString(obj: Any) -> String?{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: obj)
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            print("error converting to JSON String")
            return nil
        }
    }
    
    class func centerOf(node:SKNode) -> CGPoint {
        let centerX = node.frame.size.width/2
        let centerY = node.frame.size.height/2
        print("center is x:\(centerX), y: \(centerY)")
        return CGPoint(x: centerX, y: centerY)
    }

    

}
