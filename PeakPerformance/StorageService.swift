//
//  StorageService.swift
//  PeakPerformance
//
//  Created by Bren on 30/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation
import Firebase

/**
 This class handles save/load to Firebase storage.
 */
class StorageService
{
    // MARK: - Methods
    
    /**
        Saves a user's dream image data to the storage bucket.
        Assigns the download URL for the newly saved image as the imageURL property of the dream.
        
        - Parameters:
            - user: owner of the dream image.
            - dream: the dream being saved.
    */
    static func saveDreamImage( user: User, dream: Dream, completion: ( ) -> Void )
    {
        let dreamRef =   FIRStorage.storage( ).referenceForURL(STORAGE_REF_BASE).child(user.uid).child("\(dream.did).jpg")
        guard let imageData = dream.imageData else
        {
            print("SS: tried to save dream image that has no data")
            return
        }
        dreamRef.putData(imageData, metadata: nil ) { (metadata, error) in
            guard error == nil else
            {
                //handle error
                print("SS: error uploading image \(dream.did)")
                return
            }
            dream.imageURL = metadata!.downloadURL()
            completion( )
            print("SS: upload of \(dream.did)complete")
            
        }
    }
    
    /**
        Loads images for user's dreams from the storage bucket.
 
        - Parameters:
            - user: owner of the dreams.
    */
    static func loadDreamImages( user: User, completion: () -> Void )
    {
        if user.dreams.isEmpty
        {
            print("SS: no dream images to load")
            return
        }
        
        for i in 0...user.dreams.count - 1
        {
            let dream = user.dreams[i]
            let dreamRef =   FIRStorage.storage( ).referenceForURL(STORAGE_REF_BASE).child(user.uid).child("\(dream.did).jpg")
            dreamRef.dataWithMaxSize(2 * 1024 * 1024) { (data, error) -> Void in
                guard error == nil else
                {
                    //handle error
                    print("SS: error downloading image \(dream.did) - \(error!.localizedDescription)")
                    return
                }
                dream.imageData = data
                completion( )
                print("SS: download of \(dream.did) complete")
            }
        }
    }
    
    /**
     Loads image for user dream from the storage bucket.
     
     - Parameters:
     - user: owner of the dream.
     - dream: dream image to be loaded.
     */
    static func loadDreamImage( user: User, dream: Dream, completion: () -> Void )
    {
        let dreamRef =   FIRStorage.storage( ).referenceForURL(STORAGE_REF_BASE).child(user.uid).child("\(dream.did).jpg")
        dreamRef.dataWithMaxSize(2 * 1024 * 1024) { (data, error) -> Void in
            guard error == nil else
            {
                //handle error
                print("SS: error downloading image \(dream.did) - \(error!.localizedDescription)")
                return
            }
            dream.imageData = data
            completion( )
            print("SS: download of \(dream.did) complete")
        }
        
    }
    
    /**
     Removes dream image from the storage bucket.
     
     - Parameter:
        - user: owner of the dream.
        - dream: dream being removed.
     */
    static func removeDreamImage( user: User, dream: Dream )
    {
        let dreamRef =   FIRStorage.storage( ).referenceForURL(STORAGE_REF_BASE).child(user.uid).child("\(dream.did).jpg")
        dreamRef.deleteWithCompletion { (error) -> Void in
            guard error == nil else
            {
                //handle error
                return
            }
            print("SS: dream image \(dream.did) deleted")
        }
    }
    
}
