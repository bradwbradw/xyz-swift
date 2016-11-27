//
//  Utility.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/27/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

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
    

}
