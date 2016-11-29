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
    
    func play(item:Item, alsoRecomputePlaylist: Bool)
    func select(item: Item)
    
}

class PlayerSingleton: MediaMethods {
    
    static let sharedInstance = PlayerSingleton()

    var label: UILabel?
    var youtubePlayerView: YTPlayerView?
    var soundcloudPlayerView: UIView?
    let Spaces = SpacesSingleton.sharedInstance
    
    let youtubePlayerVars = [ "rel" : 0,
                              "playsinline" : 1]
    
    let Playlister = PlaylisterSingleton.sharedInstance
    
    private init(){
//        self.label = label
//        self.youtubePlayerView = ytView
//        self.soundcloudPlayerView = scView
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func didFinishPlaying(){
        print("did finish playing call")
        let finishedItem = self.Playlister.getNowPlaying()!
        finishedItem.setDidPlay()
        
        if let nextItem = findNextUnplayed(from: finishedItem){
            play(item: nextItem, alsoRecomputePlaylist: false)
        }
        
    }
    func findNextUnplayed(from finishedItem:Item) -> Item?{
        
        let playlist = Playlister.get(forSpace: Spaces.playing!)!.entries!
        var foundNext:Item? = nil
        
        if let finishedIndex = playlist.index(of:finishedItem) as Int?{
            
            for i in (finishedIndex+1) ..< playlist.count {
                if (foundNext == nil && !playlist[i].state.didPlay[1]){
                    foundNext = playlist[i]
                }
            }
            if(foundNext == nil){
                for i in 0 ..< finishedIndex {
                    if (foundNext != nil && !playlist[i].state.didPlay[1]){
                        foundNext = playlist[i]
                    }
                }
            }
        }
        print("found next:\(foundNext?.title)")
        return foundNext
        
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
    func play(item:Item, alsoRecomputePlaylist: Bool = true){
        
        Spaces.playing = item.parentSpace!
        
        if(alsoRecomputePlaylist){
            Playlister.recomputePlaylist(from: item)
            Utility.broadcast(notification: "rebuildPlaylistPath")
        }
    
        Spaces.playing!.unsetAllPlaying()
        item.setPlaying()
        
        print("PLAY: \(item.provider) id \(item.provider_id): \(item.title)")
        self.label?.text = item.title
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

