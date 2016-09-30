//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by mac on 23/09/2016.
//  Copyright © 2016 Hamid Belahrach. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    @IBOutlet var gifImageView: UIImageView!
    func configureImage(gif: Gif){
        self.gifImageView.image = gif.gifImage
    }
}
