//
//  Server.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/27/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import Foundation

protocol ServerSignals {
    func didLoadSpaces()
}
class Server {
    
    class func loadSpaces(){
        
        var delegate: ServerSignals?
        
        let defaultFilter: [String:Any] =
            ["where":
                ["public":true],
                 "include": ["songs"]
            ]
        var spaces:[Space] = []
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
                            print("found a space: \(rawSpace["name"]) ")
                            
                            spaces.append(Space(fromJson:rawSpace));
                            
                        }
                        delegate?.didLoadSpaces()

                    }
                }catch {
                    print("Error with Json: \(error)")
                }
                
                
            }
        }
        task.resume()
    }
    
    
}
