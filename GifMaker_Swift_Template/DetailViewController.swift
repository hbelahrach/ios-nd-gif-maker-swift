//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by mac on 23/09/2016.
//  Copyright © 2016 Hamid Belahrach. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var gifImageView : UIImageView!
    var gif: Gif?
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(true)
        
        if let gif = gif {
            super.viewWillAppear(true)
            gifImageView.image = gif.gifImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func share(sender: AnyObject) {

        let animatedGif: NSData = NSData(contentsOfURL: self.gif!.gifUrl)!
        let itemsToshare: Array = [animatedGif]
        let shareController: UIActivityViewController = UIActivityViewController(activityItems: itemsToshare, applicationActivities: nil)
        shareController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            // Return if cancelled
            if (completed) {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        self.presentViewController(shareController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
    }
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
