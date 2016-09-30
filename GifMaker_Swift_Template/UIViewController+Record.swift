//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by mac on 22/09/2016.
//  Copyright © 2016 Hamid Belahrach. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation

//Regift constants
let frameCount = 16
let delayTime : Float = 0.2
let loopCount = 0


extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func presentVideoOptions(){
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            self.launchPhotoLibrary()
        }else{
            let newGifActionsheet = UIAlertController(title: "Create new gif", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let recordVideo = UIAlertAction(title: "Record a video", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                self.launchVideoCamera()
            })
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                self.launchPhotoLibrary()
            })
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            newGifActionsheet.addAction(recordVideo)
            newGifActionsheet.addAction(chooseFromExisting)
            newGifActionsheet.addAction(cancel)
            
            presentViewController(newGifActionsheet, animated: true, completion: nil)
            let pinkColor = UIColor(red: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            newGifActionsheet.view.tintColor = pinkColor
        }
    
    }
    
    func launchVideoCamera(){
        let recordVideoController = UIImagePickerController();
        recordVideoController.sourceType = UIImagePickerControllerSourceType.Camera;
        recordVideoController.mediaTypes = [kUTTypeMovie as String];
        recordVideoController.allowsEditing = true;
        recordVideoController.delegate = self
        
        presentViewController(self, animated: true, completion: nil);
    }
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let mediaType = info[UIImagePickerControllerMediaType] as! String;
        //let start = info["_UIImagePickerControllerVideoEditingStart"] as? Float
        //let end = info["_UIImagePickerControllerVideoEditingEnd"] as? Float
        //let duration = end! - start!
        
        if mediaType == kUTTypeMovie as String {
            let videoUrl = info[UIImagePickerControllerMediaURL] as! NSURL;
//            UISaveVideoAtPathToSavedPhotosAlbum(videoUrl.path!, nil, nil, nil);
    
            self.cropVideoToSquare(videoUrl, start: 0, duration: 0)
        }
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    func convertVideoToGif(videoURL: NSURL, start: Float, duration: Float){
        let start = start
        let duration = duration
        let reGift: Regift
        if(start == 0 && duration == 0){
            reGift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        }else{
            reGift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, startTime: start as Float, duration: duration as Float, frameRate: frameCount, loopCount: loopCount)
        }
        let gifUrl = reGift.createGif()
        let gif :Gif = Gif(url: gifUrl!, videoUrl: videoURL, caption: "")
        displayGif(gif)
    }
    
//    func displayGif(url: NSURL){
//        let gifEditorVC = storyboard?.instantiateViewControllerWithIdentifier("GifEditorViewController") as! GifEditoViewController
//        //gifEditorVC.gifUrl = url
//       navigationController?.pushViewController(gifEditorVC, animated: true)
//        
//    }
    
    func displayGif(gif: Gif){
        let gifEditorVC = storyboard?.instantiateViewControllerWithIdentifier("GifEditorViewController") as! GifEditoViewController
        gifEditorVC.gif = gif
        
        dispatch_async(dispatch_get_main_queue()){
            self.dismissViewControllerAnimated(true, completion: nil);
            self.navigationController?.pushViewController(gifEditorVC, animated: true)
        }
    }
    
    func launchPhotoLibrary() {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func cropVideoToSquare(rawVideoURL: NSURL, start: NSNumber, duration: NSNumber) {
        //Create the AVAsset and AVAssetTrack
        let videoAsset = AVAsset(URL: rawVideoURL)
        let videoTrack = videoAsset.tracksWithMediaType(AVMediaTypeVideo).first
        
        // Crop to square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSizeMake((videoTrack?.naturalSize.height)!, (videoTrack?.naturalSize.height)!)
        videoComposition.frameDuration = CMTimeMake(1, 30);
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
        
        // rotate to portrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack!)
        let t1 = CGAffineTransformMakeTranslation(videoTrack!.naturalSize.height, -(videoTrack!.naturalSize.width - videoTrack!.naturalSize.height)/2)
        let t2 = CGAffineTransformRotate(t1, CGFloat(M_PI_2))
        
        let finalTransform = t2
        transformer.setTransform(finalTransform, atTime: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        //export
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        let path = self.createPath()
        exporter?.outputURL = NSURL(fileURLWithPath: path)
        exporter?.outputFileType = AVFileTypeQuickTimeMovie
        
        
         var croppedUrl = NSURL()
         exporter?.exportAsynchronouslyWithCompletionHandler({ 
            croppedUrl = exporter!.outputURL!
            self.convertVideoToGif(croppedUrl, start: Float(start), duration: Float(duration))
         })
    }
    
    
    
    
    
    
    
    //    -(void)cropVideoToSquare:(NSURL*)rawVideoURL start:(NSNumber*)start duration:(NSNumber*)duration {
    //    //Create the AVAsset and AVAssetTrack
    //
    //    videoComposition.frameDuration = CMTimeMake(1, 30);
    //
    //    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    //    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );
    //
    //    // rotate to portrait
    //    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    //    CGAffineTransform t1 = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, -(videoTrack.naturalSize.width - videoTrack.naturalSize.height) /2 );
    //    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
    //
    //    CGAffineTransform finalTransform = t2;
    //    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    //    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    //    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    //
    //    // export
    //    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality] ;
    //    exporter.videoComposition = videoComposition;
    //    NSString *path = [self createPath];
    //    exporter.outputURL = [NSURL fileURLWithPath:path];
    //    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    //
    //    __block NSURL *croppedURL;
    //
    //    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
    //    croppedURL = exporter.outputURL;
    //    [self convertVideoToGif:croppedURL start:start duration:duration];
    //    }];
    //    }

    
    
    
    
    
    
    
    
    func createPath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory =  paths.first!
        let manager = NSFileManager.defaultManager()
        var outputURL = documentsDirectory.stringByAppendingString("/output")
        
        do {
            try manager.createDirectoryAtPath(outputURL, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error)
        }
        
        do{
            outputURL = documentsDirectory.stringByAppendingString("/output.mov")
            try manager.removeItemAtPath(outputURL)
            return (outputURL)
        } catch let error {
            print(error)
            return (outputURL)
        }
    }
    

    
    
    
    
    
    

}
