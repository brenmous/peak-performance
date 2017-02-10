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
    func addDream(_ dream: Dream)
    func saveModifiedDream(_ dream: Dream)
    func deleteDream(_ dream: Dream)
}

class DreamDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    // MARK: - Properties
    
    var currentUser: User?
    var currentDream: Dream?
    var delegate: DreamDetailViewControllerDelegate?
    var imageSet: UIImage!
    var imageData: Data!
    
    let imgPicker = UIImagePickerController( )
    var dreamImageLocalURL: URL?
    
       
    // MARK: - Outlets
    
    @IBOutlet weak var dreamLabel: UILabel!
    @IBOutlet weak var dreamText: UITextView!
    @IBOutlet weak var dreamImg: UIImageView!
    
    
    // MARK: - Actions
    
    @IBAction func menuButtonPressed(_ sender: AnyObject)
    {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: AnyObject) {
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
    
    
    @IBAction func deleteButtonPressed(_ sender: AnyObject)
    {
        //dismiss keyboard
        self.view.endEditing(true)
        
        let deleteDreamAlertController = UIAlertController(title: DELETE_DREAM_ALERT_TITLE, message: DELETE_DREAM_ALERT_MSG, preferredStyle: .alert)
        
        let delete = UIAlertAction(title: DELETE_DREAM_ALERT, style: .default ) { (action) in
            guard let cd = self.currentDream else
            {
                return
            }
            self.delegate?.deleteDream(cd)
            
            if let nc = self.navigationController {
                nc.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        let cancel = UIAlertAction(title: CANCEL_DREAM_ALERT, style: .cancel, handler: nil)
        
        deleteDreamAlertController.addAction(delete)
        deleteDreamAlertController.addAction(cancel)
        present(deleteDreamAlertController, animated: true, completion: nil )
        
    }
    
    /// SOWMYA ///
    
    @IBAction func getPhotoFromCameraRoll(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            self.imgPicker.delegate = self
            self.imgPicker.sourceType = .photoLibrary
            self.imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
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
        let did = UUID( ).uuidString
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
        dreamImg.image = UIImage(data: imageData as Data)
        // delegate?.saveModifiedDream(dream)
    }

    /// SOWMYA ///
    
    // Allows user to select photo from camera roll
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageData = UIImageJPEGRepresentation(pickedImage, JPEG_QUALITY)
            imageSet = pickedImage
            dreamImg.contentMode = .scaleAspectFit
            dreamImg.image = pickedImage
            self.dreamImageLocalURL = info[UIImagePickerControllerReferenceURL] as? URL
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Dismiss the camera roll after selecting photo
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /// END SOWMYA ///
    
    // MARK: - Overridden methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentDream != nil && dreamImg.image == nil
        {
            self.updateImageandTextView()
        }
        
        self.dreamText.textColor = UIColor.black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up badge and menu bar button item
        self.setUpLeftBarButtonItem( String(self.currentUser!.numberOfUnreviwedSummaries()) )
        
        //text field delegates
        dreamText.delegate = self
        
        // text view UI configuration
        dreamText.layer.cornerRadius = 5
        dreamText.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
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
