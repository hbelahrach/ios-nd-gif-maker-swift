//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by mac on 23/09/2016.
//  Copyright © 2016 Hamid Belahrach. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController ,UICollectionViewDelegateFlowLayout , UICollectionViewDataSource, UICollectionViewDelegate, PreviewViewControllerDelegate {
    
    @IBOutlet weak var gifImageView : UIImageView!
    var savedGifs = [Gif]()
    let margin:CGFloat = 12.0
    var gifsFilePath: String {
        let directories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsPath = directories[0]
        let gifsPath = documentsPath.stringByAppendingString("/savedGifs")
        return gifsPath
    }

    @IBOutlet var imageCollection: UICollectionView!
    @IBOutlet var emptyView: UIStackView!
    
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(true)
        emptyView.hidden = !savedGifs.isEmpty
        self.navigationController?.navigationBar.hidden = savedGifs.isEmpty

        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("WelcomeScreenSeen") == false {
            let welcomeVC = storyboard?.instantiateViewControllerWithIdentifier("WelcomeViewController") as! WelcomeViewController
            self.navigationController?.pushViewController(welcomeVC, animated: false)
        }
        
    }
    
    
    @IBAction func presentOptions(sender: AnyObject) {
        self.presentVideoOptions()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = self.gifsFilePath
        let values = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        if values != nil {
            self.savedGifs = (values as? Array<Gif>)!
        }
        self.imageCollection.reloadData()

    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GifCell", forIndexPath: indexPath) as! GifCell
        cell.configureImage(savedGifs[indexPath.item])
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let width = (collectionView.frame.size.width - margin * 2)/2
        let size = CGSizeMake(width, width)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailVC.gif = savedGifs[indexPath.item]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func previewVC(gif: Gif) {
        gif.gifData = NSData(contentsOfURL: gif.gifUrl)
        self.savedGifs.append(gif)
        NSKeyedArchiver.archiveRootObject(self.savedGifs,  toFile: self.gifsFilePath)
        self.imageCollection.reloadData()
    }

    


}
