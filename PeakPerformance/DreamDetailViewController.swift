//
//  DreamDetailViewController.swift
//  PeakPerformance
//
//  Created by Sai on 13/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import UIKit
import Photos

protocol DreamDetailViewControllerDelegate {
    func addDream(image: UIImage)
    func updateDream(dream: Dream )
}
class DreamDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    //var image: UIImage!  
    
    var assetCollection: PHAssetCollection!
    var albumCreated : Bool = false
    var photosAsset: PHFetchResult!
    var assetThumbnailSize:CGSize!
    var collection: PHAssetCollection!
    var assetCollectionPlaceholder: PHObjectPlaceholder!
    
    var currentUser: User?
    var delegate: DreamDetailViewControllerDelegate?
    var currentDream: Dream?
    var imageSet: UIImage!
    @IBOutlet weak var dreamLabel: UILabel!
    @IBOutlet weak var dreamText: UITextView!
    @IBOutlet weak var dreamImg: UIImageView!
    


    
    @IBAction func savePressed(sender: AnyObject) {
        if let checkingImage = imageSet {
        delegate?.addDream(checkingImage)
        } else {
            print("no images")
        }
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
            let imageData: NSData = UIImagePNGRepresentation(pickedImage)!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //text field delegates
        dreamText.delegate = self
        dreamImg.image = imageSet
        
        createAlbum()
        // Do any additional setup after loading the view.
        
        // text view UI configuration
        dreamText.layer.cornerRadius = 5
        dreamText.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        dreamText.layer.borderWidth = 1
        dreamText.clipsToBounds = true
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
