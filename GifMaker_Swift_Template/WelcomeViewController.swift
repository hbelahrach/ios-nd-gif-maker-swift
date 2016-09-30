//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by mac on 23/09/2016.
//  Copyright © 2016 Hamid Belahrach. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var gifImageView : UIImageView!
    
    override func viewWillAppear(animated: Bool){
        
        let poc = UIImage.gifWithName("hotlineBling");
        gifImageView.image = poc;
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "WelcomeScreenSeen")
    }
    
    
    @IBAction func presentOptions(sender: AnyObject) {
        self.presentVideoOptions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
    }
}
