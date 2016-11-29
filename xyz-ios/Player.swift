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
import AVKit

protocol MediaMethods {
    
    func play(item: Item)
    func select(item: Item)
    
}

class Player: MediaMethods {
    
    var label: UILabel
    var youtubePlayerView: YTPlayerView?
    var soundcloudPlayerView: UIView?
    let Spaces = SpacesSingleton.sharedInstance
    
    let youtubePlayerVars = [ "rel" : 0,
                              "playsinline" : 1]
    
    let Playlister = PlaylisterSingleton.sharedInstance
    
    init(label: UILabel, ytView: YTPlayerView, scView: UIView){
        self.label = label
        self.youtubePlayerView = ytView
        self.soundcloudPlayerView = scView
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func didFinishPlaying(){
        let finishedItem = self.Playlister.getNowPlaying()!
        print("song done. now playing was...")
        print(finishedItem)
        
        let playlist = Playlister.get(forSpace: Spaces.playing!)!.entries!
        
        if let i = playlist.index(of:finishedItem){
            
            let nextItem: Item?
            if (i + 1 == playlist.count){
                nextItem  = playlist[0]
            } else {
                nextItem = playlist[i+1]
            }
            
            play(item: nextItem!)
        }
        
        
    }
    func showYoutube(){
        youtubePlayerView?.isHidden = false
        soundcloudPlayerView?.isHidden = true
    }
    
    func showSoundcloud(){
        youtubePlayerView?.isHidden = true
        soundcloudPlayerView?.isHidden = false
    }
    
    func stopAll(){
        youtubePlayerView?.stopVideo()
        NotificationCenter.default.post(name: Notification.Name("stopSoundCloud"),
                                        object: nil)
    }
    
    func select(item: Item){
        print("SELECT: \(item.title)")
        
    }
    func play(item:Item){
        
        Spaces.playing = item.parentSpace!
    
        Spaces.playing!.unsetAllPlaying()
        item.setPlaying()
        
        print("PLAY: \(item.provider) id \(item.provider_id) ")
        self.label.text = item.title
        Playlister.nowPlaying = item
        
        stopAll()
        if(item.provider == "youtube"){
            showYoutube()
            youtubePlayerView?.load(withVideoId: item.provider_id, playerVars: youtubePlayerVars)
            
        } else if (item.provider == "soundcloud"){
            
            showSoundcloud()
            
            NotificationCenter.default.post(name: Notification.Name("playSoundCloud"),
                                            object: nil,
                                            userInfo:["soundCloudId":item.provider_id])
        }
    }
}

class SoundcloudViewController:  AVPlayerViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.cleanNotificationThenPlay), name: Notification.Name("playSoundCloud"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stop), name: Notification.Name("stopSoundCloud"), object: nil)
        
    }
    
    func stop(){
        if let player = self.player{
            player.pause()
        }
    }
    func play(id: String){
        print("PLAY")
        self.player = AVPlayer(url: URL(string: "https://api.soundcloud.com/tracks/\(id)/stream?client_id=bbb313c3d63dc49cd5acc9343dada433")!)
        self.player?.playImmediately(atRate: 1.0)
    }
    
    func cleanNotificationThenPlay(notification: Notification){
        let soundCloudId = (notification.userInfo?["soundCloudId"] as? String)!
        self.play(id: soundCloudId)
    }
}

