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
    
        func play(provider: String, id: String){
            
            print("PLAY: \(provider) id \(id) ")
            self.label.text = provider
        }
    
    
}
