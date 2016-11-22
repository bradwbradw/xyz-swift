//
//  Player.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/20/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import Foundation
import UIKit

import Soundcloud
import youtube_ios_player_helper
import AVFoundation

protocol MediaMethods {
    
    func play(item: Item)
    
}

class Player: MediaMethods {
    
    var label: UILabel
    var youtubePlayerView: YTPlayerView?
    var scPlayer: AVPlayer?
    
    let youtubePlayerVars = [ "rel" : 0,
                       "playsinline" : 1]

    
    init(label: UILabel, ytView: YTPlayerView){
        self.label = label
        self.youtubePlayerView = ytView
    }
    
    func play(item:Item){
        
        print("PLAY: \(item.provider) id \(item.provider_id) ")
        self.label.text = item.provider+" "+item.provider_id+" "+item.title
        
        if(item.provider == "youtube"){
            
            youtubePlayerView?.load(withVideoId: item.provider_id, playerVars: youtubePlayerVars)
            
        } else if (item.provider == "soundcloud"){
            
            scPlayer = AVPlayer(url: URL(string: "https://api.soundcloud.com/tracks/\(item.provider_id)/stream?client_id=bbb313c3d63dc49cd5acc9343dada433")!)
            
            scPlayer?.play()
            
            
            
        }
    }
    
    
}
