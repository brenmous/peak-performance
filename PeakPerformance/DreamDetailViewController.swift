//
//  DreamDetailViewController.swift
//  PeakPerformance
//
//  Created by Sowmya on 13/08/2016. Saving/loading to/from local and online storage by Bren.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//


import UIKit
import Photos
import SideMenu // https://github.com/jonkykong/SideMenu


protocol DreamDetailViewControllerDelegate {
    func addDream(dream: Dream)
    func saveModifiedDream(dream: Dream)
    func deleteDream(dream: Dream)
}

class DreamDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    // MARK: - Properties
    
    var currentUser: User?
    var currentDream: Dream?
    var delegate: DreamDetailViewControllerDelegate?
    var imageSet: UIImage!
    var imageData: NSData!
    
    let imgPicker = UIImagePickerController( )
    var dreamImageLocalURL: NSURL?
    
       
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
    
    /// SOWMYA ///
    
    @IBAction func getPhotoFromCameraRoll(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            self.imgPicker.delegate = self
            self.imgPicker.sourceType = .PhotoLibrary
            self.imgPicker.allowsEditing = false
            self.presentViewController(imgPicker, animated: true, completion: nil)
        }
        else
        {
            //handle error
        }
    }
    
    /// END SOWMYA ///
    
    
    // MARK: - Methods
    
    func createNewDream( )
    {
        //dismiss keyboard
        self.view.endEditing(true)
        
        let dreamDescription = dreamText.text!
        let did = NSUUID( ).UUIDString
        let dream = Dream(dreamDesc: dreamDescription, imageLocalURL: self.dreamImageLocalURL, did: did, imageData: self.imageData)
        print("DDVC: created image with local URL \(dream.imageLocalURL)")
        delegate?.addDream(dream)
    }
    
    func updateDream( )
    {
        guard let cd = currentDream else
        {
            return
        }
        print("Updating dream")
        cd.dreamDesc = self.dreamText.text!
        cd.imageData = self.imageData!
        cd.imageLocalURL = self.dreamImageLocalURL
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
            //placeholder/file not found image
            return
        }
        dreamImg.image = UIImage(data: imageData)
        // delegate?.saveModifiedDream(dream)
    }

    /// SOWMYA ///
    
    // Allows user to select photo from camera roll
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageData = UIImageJPEGRepresentation(pickedImage, JPEG_QUALITY)
            imageSet = pickedImage
            dreamImg.contentMode = .ScaleAspectFit
            dreamImg.image = pickedImage
            self.dreamImageLocalURL = info[UIImagePickerControllerReferenceURL] as? NSURL
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Dismiss the camera roll after selecting photo
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    /// END SOWMYA ///
    
    // MARK: - Overridden methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentDream != nil && dreamImg.image == nil
        {
            self.updateImageandTextView()
        }
        
        self.dreamText.textColor = UIColor.blackColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up badge and menu bar button item
        self.setUpLeftBarButtonItem( String(self.currentUser!.numberOfUnreviwedSummaries()) )
        
        //text field delegates
        dreamText.delegate = self
        
        // text view UI configuration
        dreamText.layer.cornerRadius = 5
        dreamText.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        dreamText.layer.borderWidth = 1
        dreamText.clipsToBounds = true
        
        //Side Menu
        SideMenuManager.setUpSideMenu(self.storyboard!, user: self.currentUser!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
