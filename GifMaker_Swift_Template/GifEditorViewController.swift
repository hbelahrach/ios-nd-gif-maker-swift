//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by mac on 23/09/2016.
//  Copyright © 2016 Hamid Belahrach. All rights reserved.
//

import UIKit

class GifEditoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var gifImageView : UIImageView!
    //var gifUrl : NSURL? = nil
    var gif : Gif?
    @IBOutlet var captionTextField: UITextField?
    
    let kFrameCount: Int = 16;
    let kDelayTime: Float = 0.2;
    var kLoopCount: Int = 0; // 0 means loop forever
    
    override func viewWillAppear(animated: Bool){
        
        self.subscribeToKeyboardNotifications()
        self.title = "Add a Caption"
        
//        if let gifUrl = gifUrl {
//            super.viewWillAppear(true)
//            let gifFromRecording = UIImage.gifWithURL(gifUrl.absoluteString)
//            gifImageView.image = gifFromRecording
//        }
        
        if let gif = gif {
            super.viewWillAppear(true)
            gifImageView.image = gif.gifImage
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GifEditoViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GifEditoViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification : NSNotification){
    if (self.view.frame.origin.y >= 0) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    }
    
    func keyboardWillHide(notification : NSNotification){
    if (self.view.frame.origin.y < 0) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    }
    
    func getKeyboardHeight(notification : NSNotification)-> CGFloat {
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardFrameEnd = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey)
        let keyboardFrameEndRect:CGRect = (keyboardFrameEnd?.CGRectValue())!
        return keyboardFrameEndRect.size.height;
    }

    @IBAction func presentPreview(sender: AnyObject) {
        let previewVC = self.storyboard?.instantiateViewControllerWithIdentifier("GifPreviewViewController") as! GifPreviewViewController
        self.gif!.caption = self.captionTextField!.text
        
        let regift: Regift = Regift(sourceFileURL: self.gif!.videoURL, destinationFileURL: nil, frameCount: kFrameCount, delayTime: kDelayTime, loopCount: kLoopCount)
        let captionFont = self.captionTextField!.font
        let gifUrl = regift.createGif(caption: self.captionTextField!.text, font: captionFont)
        let newGif = Gif(url: gifUrl!, videoUrl: self.gif!.videoURL, caption: self.captionTextField!.text!)
        
        previewVC.gif = newGif;
        previewVC.delegate = self.navigationController?.viewControllers.first as! SavedGifsViewController
        self.navigationController?.pushViewController(previewVC, animated: true)
    }


}
