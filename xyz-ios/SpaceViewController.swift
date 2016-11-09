//
//  ViewController.swift
//  xyz-ios
//
//  Created by Bradley Winter on 10/11/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import UIKit

class SpaceViewController: UIViewController {
    
    var space: AnyObject?

    @IBOutlet weak var spaceTitle: UILabel!
    
    @IBOutlet weak var firstSong: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("i got a space: ")
        print(space?["name"] as Any)
        spaceTitle.text = space!["name"] as? String
        
        var songs = space!["songs"] as? [AnyObject];
        
        firstSong.text = songs?[0]["title"] as? String
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

