//
//  GifPreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by mac on 24/09/2016.
//  Copyright © 2016 Hamid Belahrach. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate {
    func previewVC(gif: Gif)
}

class GifPreviewViewController: UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var gif:Gif!
    var delegate: PreviewViewControllerDelegate? = nil
    
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
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
    }
    
    @IBAction func share(sender: AnyObject) {
        let animatedGif: NSData = NSData(contentsOfURL: self.gif.gifUrl)!
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
    
    
    
    @IBAction func createAndSave(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        delegate?.previewVC(self.gif)
    }
   
}




