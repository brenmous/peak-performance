//
//  DreamCollectionViewController.swift
//  PeakPerformance
//
//  Created by Sai on 13/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SideMenu
import Photos //for getting image using local URL
import AssetsLibrary //for saving image and getting local URL

private let reuseIdentifier = "Cell"


class DreamCollectionViewController: UICollectionViewController, DreamDetailViewControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var currentUser: User?
    
    var currentDream: Dream?
    
    var Dreams = [UIImage]()
    
    /// Indicates the index path of the cell
    var gloablindexPathForRow: Int?
    
    let storageService = StorageService( )
    
    // MARK: - Actions
    
    @IBAction func unwindFromDDVC(segue: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject)
    {
        self.presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
    @IBAction func cellLongPress(sender: AnyObject) {
        print("long Pressed")
    }
    
    
    // MARK: - Methods
    // These need to be commented.
    
    func addDream(dream: Dream) {
        guard let cu = currentUser else
        {
            //user not available? handle it here
            return
        }
        
        
        storageService.saveDreamImage(cu, dream: dream) { () in
            DataService.saveDream(cu.uid, dream: dream)
        }
        
        
        cu.dreams.append(dream)
        
        
        print("DVC: image added")
        print("DVC: dream count \(self.currentUser!.dreams.count)")
        self.collectionView?.reloadData()
        
        
    }
    
    func saveModifiedDream(dream: Dream) {
        print("\(dream.dreamDesc)") // DEBUG
        guard let cu = currentUser else
        {
            //user not available handle it HANDLE IT!
            return
        }
        
        storageService.saveDreamImage(cu, dream: dream) { ()
            DataService.saveDream(cu.uid, dream: dream)
        }
        
        self.collectionView?.reloadData()
        
        
    }
    
    func deleteDream(dream: Dream) {
        guard let cu = currentUser else
        {
            return
        }
        storageService.removeDreamImage(cu, dream: dream)
        DataService.removeDream(cu.uid, dream: dream)
        cu.dreams.removeAtIndex(gloablindexPathForRow!)
        self.collectionView?.reloadData( )
        
    }
    
    /// Attempts to fetch dream images from local photo library. If it can't, fetches them from Firebase Storage.
    func getDreamImages( )
    {
        guard let cu = self.currentUser else
        {
            print("DVC: no user")
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
                        print("DVC: got dream image \(dream.did) from photo library")
                        self.collectionView?.reloadData( )
                    }
                }
                
            }
            //...else, get it from Firebase Storage.
            if dream.imageLocalURL == nil || photo == nil
            {
                self.storageService.loadDreamImage(cu, dream: dream){ () in
                    self.collectionView?.reloadData()
                    print("DVC: got dream image \(dream.did) from storage bucket")
                    //In here we can save the image back to the user's device but it's probably not a good idea.
                }
            }
        }
        
    }





    // MARK: - Overriden functions
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //check if a monthly review is needed
        if self.currentUser!.checkMonthlyReview()
        {
            self.presentViewController(UIAlertController.getReviewAlert( ), animated: true, completion: nil)
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
    
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        var numOfSection: NSInteger = 0
        
        if (currentUser?.dreams.count) > 0 {
            
            self.collectionView!.backgroundView = nil
            numOfSection = 1
            
            
        } else {
            
            var dreamPlaceholderView : UIImageView
            dreamPlaceholderView  = UIImageView(frame:CGRectMake(0, 0, self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height));
            dreamPlaceholderView.image = UIImage(named:DREAM_PLACEHOLDER)
            self.collectionView?.backgroundView = dreamPlaceholderView
        }
        return numOfSection
    }

    
    
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
                gloablindexPathForRow = indexPath.row
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
