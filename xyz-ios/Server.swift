//
//  Server.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/27/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import Foundation
import UIKit

protocol ServerSignals {
    func didLoad(image: UIImage?)
}
class Server {
    
    var delegate: ServerSignals?
    let Spaces = SpacesSingleton.sharedInstance
    
    func loadSpaces(){
        
        let defaultFilter: [String:Any] =
            ["where":
                ["public":true],
             "include": ["songs"]
        ]
        
        let filterJsonString = Utility.objToJsonString(obj:defaultFilter)!
        let filterJsonStringUrlEncoded = filterJsonString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let urlObj: URL = URL(string: "https://xyz.gs/api/spaces?filter=\(filterJsonStringUrlEncoded)")!
        let urlRequest: URLRequest = URLRequest(url: urlObj)
        print("downloaded xyz spaces from \(urlObj.absoluteString)");
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            if((error) != nil){
                print("error loading space data:  \(error)")
            }
            
            let httpResponse = response as! HTTPURLResponse
            if (httpResponse.statusCode == 200) {
                print("spaces downloaded successfully.")
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [ [String: AnyObject] ]
                    if let spacesFromJson = json as [ [String: AnyObject] ]? {
                        for rawSpace in spacesFromJson {
                            self.Spaces.upsert(space: Space(fromJson:rawSpace));
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name("downloadedSpaces"),
                                                        object: nil)
                    }
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func loadImage(url: String){
        
        print("will load image for item at url \(url)")
        
        let urlObj: URL = URL(string: url)!
        let urlRequest: URLRequest = URLRequest(url: urlObj)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            if
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data,
                let image = UIImage(data: data),
                error == nil
            {
                print("downloaded image from \(urlObj.absoluteString)");
                self.delegate?.didLoad(image: image)
                
            }else {
                print("could not load image...")
                print(error ?? "no error")
                print(response ?? "no http response")
                self.delegate?.didLoad(image: nil)
            }
        }
        task.resume()
        
        //self.delegate?.didLoad(image:nil)
        
    }
    
    
}
