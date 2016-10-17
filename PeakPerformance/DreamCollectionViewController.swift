//
//  DreamCollectionViewController.swift
//  PeakPerformance
//
//  Created by Sowmya on 13/08/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import UIKit
import SideMenu // https://github.com/jonkykong/SideMenu
import Photos
import AssetsLibrary
import TwitterKit // https://fabric.io/kits/ios/twitterkit

private let reuseIdentifier = "Cell"


class DreamCollectionViewController: UICollectionViewController, DreamDetailViewControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    let dataService = DataService()
    
    // User logged in
    var currentUser: User?
    var currentDream: Dream?
    var Dreams = [UIImage]()
    
    /// Indicates the index path of the cell
    var globalindexPathForRow: Int?
    
    // MARK: - Actions
    
    @IBAction func unwindFromDDVC(segue: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject)
    {
        self.presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
    // MARK: - Methods
    
    func addDream(dream: Dream) {
        guard let cu = currentUser else
        {
            //user not available? handle it here
            return
        }
        
        StorageService.saveDreamImage(cu, dream: dream) { () in
            self.dataService.saveDream(cu.uid, dream: dream)
        }
        
        
        cu.dreams.append(dream)
        
        self.collectionView?.reloadData()
        
        shareOnTwitter(dream)
        
    }
    
    func saveModifiedDream(dream: Dream) {

        guard let cu = currentUser else
        {
            return
        }
        
        StorageService.saveDreamImage(cu, dream: dream) { ()
            self.dataService.saveDream(cu.uid, dream: dream)
        }
        
        self.collectionView?.reloadData()
        
    }
    
    func deleteDream(dream: Dream) {
        guard let cu = currentUser else
        {
            return
        }
        StorageService.removeDreamImage(cu, dream: dream)
        self.dataService.removeDream(cu.uid, dream: dream)
        cu.dreams.removeAtIndex(globalindexPathForRow!)
        self.collectionView?.reloadData( )
        
    }
    
    /// Attempts to fetch dream images from local photo library. If it can't, fetches them from Firebase Storage.
    func getDreamImages( )
    {
        guard let cu = self.currentUser else
        {
            return
        }
        for dream in cu.dreams
        {
            //If the image exists locally, get it from the photo library...
            var photo: PHAsset? = nil
            if let url = dream.imageLocalURL
            {
                let fetchResult = PHAsset.fetchAssetsWithALAssetURLs([url], options: nil)
            
                photo = fetchResult.firstObject as? PHAsset
                if photo != nil
                {
                    PHImageManager( ).requestImageDataForAsset(photo!, options: nil) { (data, info, orientation, dict) in
                        dream.imageData = data!
                        self.collectionView?.reloadData( )
                    }
                }
                
            }
            //...else, get it from Firebase Storage.
            if dream.imageLocalURL == nil || photo == nil
            {
                StorageService.loadDreamImage(cu, dream: dream){ () in
                    self.collectionView?.reloadData()
                }
            }
        }
        
    }
    
    /// BREN ///
    /// Shares a dream goal on twitter.
    func shareOnTwitter(dream: Dream)
    {
        if NSUserDefaults().boolForKey(USER_DEFAULTS_TWITTER)
        {
            let composer = TWTRComposer()
            composer.setText(TWITTER_MESSAGE_DREAM(dream))
            if dream.imageData != nil { composer.setImage(UIImage(data: dream.imageData!)!) }
            composer.showFromViewController(self) { result in
            }
        }
    }
    /// END BREN ///


    // MARK: - Overriden functions
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.setUpLeftBarButtonItem(String(self.currentUser!.numberOfUnreviwedSummaries()))
        
        //check if a yearly review is needed
        if self.currentUser!.checkYearlyReview()
        {
            //self.currentUser!.allMonthlyReviewsFromLastYear()
            self.presentViewController(UIAlertController.AnnualReviewAlert(self.tabBarController as! TabBarViewController), animated: true, completion: nil)
        }
            //only check for monthly reviews if the year hasn't changed, because if it has we know we need 12 months of reviews
        else
        {
            //check if a monthly review is needed
            if self.currentUser!.checkMonthlyReview()
            {
                self.presentViewController(UIAlertController.getReviewAlert(self.tabBarController as! TabBarViewController), animated: true, completion: nil)
            }
        }

        
        //reload the view
        self.collectionView?.reloadData()
      
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up badge and menu bar button item
        self.setUpLeftBarButtonItem("1")
        
        //Get data from tab bar view controller
        let tbvc = self.tabBarController as! TabBarViewController
        
        guard let cu = tbvc.currentUser else
        {
            return
        }
        self.currentUser = cu
        
        print("DVC: got user \(cu.email) with \(cu.dreams.count) dreams")
        
        self.getDreamImages()
        
        SideMenuManager.setUpSideMenu(self.storyboard!, user: cu)
        
        // set up badge and menu bar button item
        self.setUpLeftBarButtonItem( String(self.currentUser!.numberOfUnreviwedSummaries()) )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    /// SOWMYA ///
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        var numOfSection: NSInteger = 0
        
        if (currentUser?.dreams.count) > 0 {
            
            self.collectionView!.backgroundView = nil
            numOfSection = 1
            
            
        } else {
            // show dream placeholder if there are no dreams
            var dreamPlaceholderView : UIImageView
            dreamPlaceholderView  = UIImageView(frame:CGRectMake(0, 0, self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height));
            dreamPlaceholderView.image = UIImage(named:DREAM_PLACEHOLDER)
            dreamPlaceholderView.contentMode = .ScaleAspectFill
            self.collectionView?.backgroundView = dreamPlaceholderView
        }
        return numOfSection
    }
    /// END SOWMYA

    // Used to count the number of dreams the user has
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUser!.dreams.count
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let labelView = cell.viewWithTag(2) as! UILabel
        
        labelView.text = currentUser!.dreams[indexPath.row].dreamDesc
        guard let userImageData = currentUser!.dreams[indexPath.row].imageData else
        {
            //set image as placeholder
            imageView.image = UIImage(contentsOfFile: "business-cat.jpg")
            return cell
        }
        imageView.image = UIImage(data: userImageData)
        return cell
    }
    
    // MARK: - Collection View Layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        return  CGSize(width: width, height: width)
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ADD_DREAM_SEGUE
        {
            let dvc = segue.destinationViewController as! DreamDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
        }
        else if segue.identifier == EDIT_DREAM_SEGUE
        {
            let dvc = segue.destinationViewController as! DreamDetailViewController
            dvc.delegate = self
            dvc.currentUser = self.currentUser
            let cell = sender as! UICollectionViewCell
            if let indexPath = self.collectionView?.indexPathForCell(cell)
            {
                dvc.currentDream = currentUser!.dreams[indexPath.row]
                self.globalindexPathForRow = indexPath.row
            }
        }
    }
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}
