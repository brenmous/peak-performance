//
//  DreamCollectionViewController.swift
//  PeakPerformance
//
//  Created by Sai on 13/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

protocol DreamDataService
{
    func saveDream(uid: String, dream: Dream)
    func removeDream(uid: String, dream: Dream)
}

class DreamCollectionViewController: UICollectionViewController {
    
    
    /*@IBAction func addDreamPressed(sender: AnyObject?) {
        prepareForSegue(ADD_DREAM_SEGUE, sender: self)
    }*/
    
    var currentUser: User?
    
    
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUser!.dreams.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        return cell
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == ADD_DREAM_SEGUE
//        {
//            let dvc = segue.destinationViewController as! DreamDetailViewController
//            dvc.delegate = self
//            dvc.currentUser = self.currentUser
//        }
//        else if segue.identifier == EDIT_DREAM_SEGUE
//        {
//            let dvc = segue.destinationViewController as! DreamDetailViewController
//            //dvc.delegate = self
//            dvc.currentUser = self.currentUser
//            if let indexPath = self.collectionView?.indexPathForCell
//            {
//                dvc.currentDream = currentUser!.dreams[indexPath.cell]
//            }
//        }
//    }

    // MARK: UICollectionViewDelegate

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
