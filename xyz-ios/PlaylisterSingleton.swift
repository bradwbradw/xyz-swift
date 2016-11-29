//
//  SpacesSingleton.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/26/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import Foundation
import SpriteKit

class PlaylisterSingleton {
    
    static let sharedInstance = PlaylisterSingleton()
    
    let Spaces = SpacesSingleton.sharedInstance
    
    var map: [String: Playlist] = [:]
    var nowPlaying: Item?
    
    func getNowPlaying() -> Item?{
        if let now = nowPlaying {
            return now
        } else {
            return nil
        }
    }
    
    private init(){
        print("creating Playlister singleton")
    }
    
    func upsert(fromSpace: Space){
        upsert(id: fromSpace.id, playlist: Playlist(space: fromSpace, fromItem: nil))
    }
    
    func upsert(id: String, playlist: Playlist){
        self.map[id] = playlist
//        print("upserted playlist for space \(id). Now map looks like...")
//        print(map)
    }
    
    func recomputePlaylist(from item: Item){
        let newPlaylist = Playlist(space: Spaces.viewing!, fromItem: item)
        upsert(id: Spaces.viewing!.id, playlist: newPlaylist)
    }
    
    func get(forSpace: Space) -> Playlist?{
        if let playlist = self.map[forSpace.id]{
            return playlist
        } else {
            print("playlist not found for space \(forSpace)")
            return nil
        }
    }
    
    func getPoints(forSpace: Space) -> [CGPoint] {
        let items = get(forSpace: forSpace)!.entries
        var points:[CGPoint] = []
        
        for item in items!{
            points.append(item.position)
        }
        return points
    }
    
    
    class Playlist {
        
        var entries:[Item]?
        
        let Playlister = PlaylisterSingleton.sharedInstance
        
        init(space: Space, fromItem item: Item?){
            recompute(space: space, fromItem: item)
        }
        func describe(){
            if(entries == nil){
                print("playlist is empty")
            }
            for item in entries! {
                print("x:\(item.x) y:\(item.y) \(item.title)")
            }
        }
        
        func recompute(space: Space, fromItem: Item?){
            
            struct distanceToItem {
                var distance: CGFloat
                var item: Item
            }
            
            func distancesToOtherItems (item: Item, others: [Item]) -> [distanceToItem]{
                var distances: [distanceToItem] = []
                
                for other in others {
                    distances.append( distanceToItem(distance: item.distanceTo(item:other), item: other) )
                }
                
                func closer(_ first: distanceToItem, _ second: distanceToItem) -> Bool{
                    return first.distance < second.distance
                }
                
                return distances.sorted(by:closer)
            }
            
            func sortByNearest (items: [Item], seed: Item){
                
                var sorted:[Item] = []
                var safety = 0
                
                func sort(unvisited: [Item], current: Item){
                    
                    var newUnvisited = unvisited
                    safety += 1
                    
                    if(safety > 1000){
                        print(" recursion too deep in Playlist.recompute()")
                        return
                    }
                    
                    if (unvisited.count == 0){
                        return
                    }
                    
                    sorted.append(current)
                    
                    if (unvisited.count == 1){
                        _ = sort(unvisited: [], current: unvisited[0])
                        return
                    }
                    
                    guard let i = unvisited.index(of:current) else {
                        print(" the univisted array does not have the item that was just added to sorted!!")
                        return
                    }
                    newUnvisited.remove(at: i)
                    
                    let otherDistances = distancesToOtherItems(item: current, others: newUnvisited)
                    let nextItem = otherDistances[0].item
                    
                    _ = sort(unvisited: newUnvisited, current: nextItem)
                    
                }
                
                _ = sort(unvisited:items, current: seed)
                
                self.entries = sorted
                
            }
            
            // TODO check for if we can actually play it
            guard let items = space.items else {
                print("space has no items property!")
                return
            }
            
            if (items.count == 0){
                print("space items property has count 0!")
                return
            }
            
            var seed:Item?
            
            // TODO check to see if now playing is in current space
            
            if let from = fromItem {
                seed = from
            } else if let from = Playlister.getNowPlaying(){  // TODO && nowPlayingIsInCurrentSpace()
                seed = from
            } else if let firstSong = space.firstSong{
                seed = firstSong
            }
            if (seed == nil){
                seed = items[0] // TODO change this to check for date_saved instead of just first one arbitrarily, just like: https://github.com/bradwbradw/xyz/blob/master/client/scripts/services/playlister.js#L138
            }
            
            if ( items.count > 1) {
                sortByNearest(items: items, seed: seed!)
            }
            print("done recomputing playlist for space \(space.name)")
            
        }
        
    }
    
}

