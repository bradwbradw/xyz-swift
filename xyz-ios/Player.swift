//
//  Player.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/20/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import Foundation
import UIKit

class Player: MediaMethods {
    
    var label: UILabel

    init(label: UILabel){
        self.label = label
    }
    
    func play(item:Item){
        
            print("PLAY: \(item.provider) id \(item.provider_id) ")
            self.label.text = item.provider+" "+item.provider_id+" "+item.title
        }
    
    
}
