//
//  DreamCollectionViewController.swift
//  PeakPerformance
//
//  Created by Sai on 13/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import SideMenu

private let reuseIdentifier = "Cell"


class DreamCollectionViewController: UICollectionViewController, DreamDetailViewControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var currentUser: User?
    
    var currentDream: Dream?
    
    var Dreams = [UIImage]()
    
    /// Indicates the index path of the cell
    var gloablindexPathForRow: Int?
    
    let dataService = DataService( )
    
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
        cu.dreams.append(dream)
        
        dataService.saveDream(cu.uid, dream: dream)
        
        print("image added")
        print("Dream count \(currentUser!.dreams.count)")
        self.collectionView?.reloadData()
        
    }
    
    func saveModifiedDream(dream: Dream) {
        print("\(dream.dreamDesc)") // DEBUG
        guard let cu = currentUser else
        {
            //user not available handle it HANDLE IT!
            return
        }
        
        dataService.saveDream(cu.uid, dream: dream)
        
    }
    
    func deleteDream(dream: Dream) {
        guard let cu = currentUser else
        {
            return
        }
        cu.dreams.removeAtIndex(gloablindexPathForRow!)
        dataService.removeDream(cu.uid, dream: dream)
        
    }

    
    
    // MARK: - Overriden functions
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //Get data from tab bar view controller
        let tbvc = self.tabBarController as! TabBarViewController
        
        guard let cu = tbvc.currentUser else
        {
            return
        }
        self.currentUser = cu
        collectionView?.reloadData( )
        print("DVC: got user \(currentUser!.email) with \(cu.dreams.count) dreams")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SideMenuManager.setUpSideMenu(self.storyboard!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUser!.dreams.count
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let labelView = cell.viewWithTag(2) as! UILabel
        
        labelView.text = currentUser!.dreams[indexPath.row].dreamDesc
        //        imageView.image = Dreams[indexPath.row]
        let userImageData = currentUser!.dreams[indexPath.row].dreamImg
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
