//
//  MediaPlayerViewController.swift
//  xyz-ios
//
//  Created by Bradley Winter on 11/20/16.
//  Copyright © 2016 Bradley Winter. All rights reserved.
//

import UIKit
//
//
//class Media {
//    var delegate: MediaMethods?
//    
//    func doPlay(item: Item?){
//        print("doPlay")
//        print(item as Any)
////        delegate?.play(item: item)
//    }
//}
//

class MediaPlayerViewController: UIViewController {
    
    @IBOutlet weak var mediaItemName: UILabel!
    
    //var mediaListener: MediaListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.mediaListener = MediaListener(label: mediaItemName)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.playItem), name: Notification.Name("playItem"), object: nil)

    }
//    
//    class MediaListener: MediaMethods {
//        
//        let media = Media()
//        let label: UILabel?
//        
//        init(label: UILabel) {
//            self.label = label
//            media.delegate = self
////            media.doPlay(item: item)
//        }
//        
//        func updateLabel(text: String){
//            label?.text = text
//        }
//
//        func play(item: Item?){
//            guard let title = item?.title else {
//                print(" no title found ")
//                return;
//            }
//            print("PLAY. item is...")
//            print(item as Any)
//            updateLabel(text: title)
//        }
//        
    }

    
//    
//    func playItem(notification : Notification){
//        if let mediaInfo = notification.userInfo?["mediaInfo"] as? String {
//            print("i have event and i have mediaItemName outlet!")
//            mediaItemName.text = mediaInfo
//            print(mediaInfo)
//        }
//    }
//
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
