//
//  StorageService.swift
//  PeakPerformance
//
//  Created by Bren - bmoush@gmail.com on 30/08/2016.
//  Copyright © 2016 Bren Moushall, Benjamin Chiong, Sowmya Devarakonda. All rights reserved.
//

import Foundation
import Firebase // https://firebase.google.com

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
    static func saveDreamImage( _ user: User, dream: Dream, completion: @escaping ( ) -> Void )
    {
        let dreamRef =   FIRStorage.storage( ).reference(forURL: STORAGE_REF_BASE).child(user.uid).child("\(dream.did).jpg")
        guard let imageData = dream.imageData else { return }
        dreamRef.put(imageData as Data, metadata: nil ) { (metadata, error) in
            guard error == nil else
            {
                print("StorageService - saveDreamImage(): \(error?.localizedDescription)")
                return
            }
            dream.imageURL = metadata!.downloadURL()
            completion( )
        }
    }
    
    /**
        Loads images for user's dreams from the storage bucket.
 
        - Parameters:
            - user: owner of the dreams.
    */
    static func loadDreamImages( _ user: User, completion: @escaping () -> Void )
    {
        if user.dreams.isEmpty{ return }
        
        for i in 0...user.dreams.count - 1
        {
            let dream = user.dreams[i]
            let dreamRef =   FIRStorage.storage( ).reference(forURL: STORAGE_REF_BASE).child(user.uid).child("\(dream.did).jpg")
            dreamRef.data(withMaxSize: Int64(DREAM_IMAGE_SIZE)) { (data, error) -> Void in
                guard error == nil else
                {
                    print("StorageService - loadDreamImages(): \(error?.localizedDescription)")
                    return
                }
                dream.imageData = data
                completion( )
            }
        }
    }
    
    /**
     Loads image for user dream from the storage bucket.
     
     - Parameters:
     - user: owner of the dream.
     - dream: dream image to be loaded.
     */
    static func loadDreamImage( _ user: User, dream: Dream, completion: @escaping () -> Void )
    {
        let dreamRef =   FIRStorage.storage( ).reference(forURL: STORAGE_REF_BASE).child(user.uid).child("\(dream.did).jpg")
        dreamRef.data(withMaxSize: Int64(DREAM_IMAGE_SIZE)) { (data, error) -> Void in
            guard error == nil else
            {
                print("StorageService - loadDreamImage(): \(error?.localizedDescription)")
                return
            }
            dream.imageData = data
            completion( )
        }
        
    }
    
    /**
     Removes dream image from the storage bucket.
     
     - Parameter:
        - user: owner of the dream.
        - dream: dream being removed.
     */
    static func removeDreamImage( _ user: User, dream: Dream )
    {
        let dreamRef =   FIRStorage.storage( ).reference(forURL: STORAGE_REF_BASE).child(user.uid).child("\(dream.did).jpg")
        dreamRef.delete { (error) -> Void in
            guard error == nil else
            {
                print("StorageService - removeDreamImage(): \(error?.localizedDescription)")
                return
            }
        }
    }
    
}
