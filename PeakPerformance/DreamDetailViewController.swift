//
//  DreamDetailViewController.swift
//  PeakPerformance
//
//  Created by Sai on 13/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import Photos
import SideMenu



protocol DreamDetailViewControllerDelegate {
    func addDream(dream: Dream)
    func updateDream(dream: Dream )
}
class DreamDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    
// MARK: - Collection View Properties
    var assetCollection: PHAssetCollection!
    var albumCreated : Bool = false
    var photosAsset: PHFetchResult!
    var assetThumbnailSize:CGSize!
    var collection: PHAssetCollection!
    var assetCollectionPlaceholder: PHObjectPlaceholder!

// MARK: - User Properties
    var currentUser: User?
    var currentDream: Dream?
    var delegate: DreamDetailViewControllerDelegate?
    var imageSet: UIImage!
    var imageData: NSData!
    
// MARK: IBOutlets
    @IBOutlet weak var dreamLabel: UILabel!
    @IBOutlet weak var dreamText: UITextView!
    @IBOutlet weak var dreamImg: UIImageView!
    
    @IBAction func menuButtonPressed(sender: AnyObject)
    {
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
// MARK: IBActions
    @IBAction func savePressed(sender: AnyObject) {
        
        createNewDream( )
    }


    func createNewDream( )
    {
        let dreamDescription = dreamText.text!
        let did = NSUUID( ).UUIDString
        let dream = Dream(dreamDesc: dreamDescription, dreamImg: imageData, did: did)
        delegate?.addDream(dream)
    }
    
    /// Updates image and description if current dream is available
    func updateImageandTextView( )
    {
        guard let cd = currentDream else
        {
            return
        }
        dreamText.text = cd.dreamDesc
        let imageData = cd.dreamImg
        dreamImg.image = UIImage(data: imageData)
        

    }
    
    @IBAction func getPhotoFromCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imgPicker.allowsEditing = false
            self.presentViewController(imgPicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func getPhotoFromCameraRoll(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imgPicker.allowsEditing = false // Do we allow the user to edit images?
            self.presentViewController(imgPicker, animated: true, completion: nil)
            
            
        }
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        
//        dreamImg.image = image
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        delegate?.addImage(image)
//    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageData = UIImagePNGRepresentation(pickedImage)!
            imageSet = pickedImage
            dreamImg.contentMode = .ScaleAspectFit
            dreamImg.image = pickedImage
            UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
        }

            dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        
//        //let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        self.dismissViewControllerAnimated(true, completion: nil)
//        dreamImg.image = image
//        
//        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
//            let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image!)
//            let assetPlaceholder = assetRequest.placeholderForCreatedAsset
//            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset)
//            albumChangeRequest?.addAssets([assetPlaceholder!])
//            }, completionHandler: { success, error in
//                print("added image to album")
//                print(error)
//                
//               //self.showImages()
//        })
//    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
         self.dismissViewControllerAnimated(true, completion: nil)
         // performSegueWithIdentifier("unwindFromDDVC", sender: self)
    }
 
    func createAlbum() {
       
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", "Peak Performance")
        let collection : PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
       
        if let obj: AnyObject = collection.firstObject {
            self.albumCreated = true
            assetCollection = collection.firstObject as! PHAssetCollection
        } else {
    
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let createAlbumRequest : PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle("Peak Performance")
                self.assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
                }, completionHandler: { success, error in
                    self.albumCreated = (success ? true: false)
                    
                    if (success) {
                        let collectionFetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([self.assetCollectionPlaceholder.localIdentifier], options: nil)
                        print(collectionFetchResult)
                        self.assetCollection = collectionFetchResult.firstObject as! PHAssetCollection
                    }
            })
        }
    }

    // MARK: - Overridden methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentDream != nil
        {
            self.updateImageandTextView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //text field delegates
        dreamText.delegate = self
  
        
        createAlbum()
        // Do any additional setup after loading the view.
        
        // text view UI configuration
        dreamText.layer.cornerRadius = 5
        dreamText.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        dreamText.layer.borderWidth = 1
        dreamText.clipsToBounds = true
        
        //Side Menu
        SideMenuManager.setUpSideMenu(self.storyboard!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - keyboard stuff
    /// Work around for dismissing keyboard on text view.
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            textView.resignFirstResponder( )
            //validator.validate(self)
            return false
        }
        else
        {
            return true
        }
    }
    override func touchesBegan( touchers: Set<UITouch>, withEvent event: UIEvent? )
    {
        self.view.endEditing(true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
