//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by mac on 24/09/2016.
//  Copyright © 2016 Hamid Belahrach. All rights reserved.
//

import Foundation
import UIKit

class Gif: NSObject, NSCoding {
    
    var gifUrl: NSURL!
    var caption: String!
    var gifImage: UIImage!
    var videoURL: NSURL!
    var gifData: NSData!
    
    
    init(url: NSURL,videoUrl: NSURL,caption: String){
        self.gifUrl = url
        self.videoURL = videoUrl
        self.caption = caption
        self.gifImage = UIImage.gifWithURL(gifUrl.absoluteString!)
        self.gifData = nil
        
    }
    
    func initWithName(name: String){
    
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.gifUrl,forKey: "gifUrl")
        aCoder.encodeObject(self.caption,forKey: "gifCaption")
        aCoder.encodeObject(self.gifImage,forKey: "gifImage")
        aCoder.encodeObject(self.videoURL,forKey: "gifVidUrl")
        aCoder.encodeObject(self.gifData,forKey: "gifData")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.gifUrl = aDecoder.decodeObjectForKey("gifUrl") as! NSURL
        self.caption = aDecoder.decodeObjectForKey("gifCaption") as! String
        self.gifImage = aDecoder.decodeObjectForKey("gifImage") as! UIImage
        self.videoURL = aDecoder.decodeObjectForKey("gifVidUrl") as! NSURL
        self.gifData = aDecoder.decodeObjectForKey("gifData") as! NSData
    }
    
}
