//
//  DreamDetailViewController.swift
//  PeakPerformance
//
//  Created by Sowmya on 13/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//


// TODO: - Change unmutated properties to constants ("let")
// TODO: - Refactor properties that do not need to be global in class
// TODOL - Comment properties and methods

import UIKit
import Photos
import SideMenu



protocol DreamDetailViewControllerDelegate {
    func addDream(dream: Dream)
    func saveModifiedDream(dream: Dream)
    func deleteDream(dream: Dream)
}
class DreamDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    // MARK: - Properties
    // These need to be refactored and commented.
    
    var assetCollection: PHAssetCollection!
    var albumCreated : Bool = false
    var photosAsset: PHFetchResult!
    var assetThumbnailSize:CGSize!
    var collection: PHAssetCollection!
    var assetCollectionPlaceholder: PHObjectPlaceholder!
    var currentUser: User?
    var currentDream: Dream?
    var delegate: DreamDetailViewControllerDelegate?
    var imageSet: UIImage!
    var imageData: NSData!
    
    // MARK: - Outlets
    
    @IBOutlet weak var dreamLabel: UILabel!
    @IBOutlet weak var dreamText: UITextView!
    @IBOutlet weak var dreamImg: UIImageView!
    
    
    // MARK: - Actions
    
    @IBAction func menuButtonPressed(sender: AnyObject)
    {
        presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        //dismiss keyboard
        self.view.endEditing(true)
        
        //if there's no current dream, make a new one...
        if currentDream == nil
        {
            createNewDream( )
        }
            //...otherwise modify the referenced goal
        else
        {
            updateDream( )
            
            print("DVC: Update dream") //DEBUG
        }
    }
    
    
    @IBAction func deleteButtonPressed(sender: AnyObject)
    {
        //dismiss keyboard
        self.view.endEditing(true)
        
        let deleteDreamAlertController = UIAlertController(title: DELETE_DREAM_ALERT_TITLE, message: DELETE_DREAM_ALERT_MSG, preferredStyle: .Alert)
        
        let delete = UIAlertAction(title: DELETE_DREAM_ALERT, style: .Default ) { (action) in
            guard let cd = self.currentDream else
            {
                return
            }
            self.delegate?.deleteDream(cd)
            
            if let nc = self.navigationController {
                nc.popViewControllerAnimated(true)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        let cancel = UIAlertAction(title: CANCEL_DREAM_ALERT, style: .Cancel, handler: nil)
        
        deleteDreamAlertController.addAction(delete)
        deleteDreamAlertController.addAction(cancel)
        presentViewController(deleteDreamAlertController, animated: true, completion: nil )
        
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
    
    
    // MARK: - Methods
    //These need to be commented.
    
    func createNewDream( )
    {
        //dismiss keyboard
        self.view.endEditing(true)
        
        let dreamDescription = dreamText.text!
        let did = NSUUID( ).UUIDString
        let dream = Dream(dreamDesc: dreamDescription, did: did, imageData: self.imageData)
        delegate?.addDream(dream)
    }
    
    func updateDream( )
    {
        guard let cd = currentDream else
        {
            return
        }
        cd.dreamDesc = dreamText.text!
        imageData = UIImageJPEGRepresentation(dreamImg.image!, JPEG_QUALITY)
        cd.imageData = imageData!
        delegate?.saveModifiedDream(cd)
    }
    
    /// Updates image and description if current dream is available
    func updateImageandTextView( )
    {
        guard let cd = currentDream else
        {
            return
        }
        dreamText.text = cd.dreamDesc
        
        guard let imageData = cd.imageData else
        {
            dreamImg.image = UIImage(contentsOfFile: "business-cat.jpg")
            return
        }
        dreamImg.image = UIImage(data: imageData)
        
        // delegate?.saveModifiedDream(dream)
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageData = UIImageJPEGRepresentation(pickedImage, JPEG_QUALITY)
            imageSet = pickedImage
            dreamImg.contentMode = .ScaleAspectFit
            dreamImg.image = pickedImage
            UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
