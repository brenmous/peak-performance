//
//  Dream.swift
//  PeakPerformance
//
//  Created by Sai on 15/08/2016.
//  Copyright © 2016 derridale. All rights reserved.
//

import Foundation

/* This class represents the user's dream. */
class Dream {
    
    /// This is the description of the user's dream.
    var dreamDesc: String
    
    /// This is the download URL for fetching the image from the Firebase Storage bucket.
    var imageURL: NSURL?
    
    /// This is the local URL of the photos location in the photo library.
    var imageLocalURL: NSURL?
    
    /// This is the image data for a user's deam image.
    var imageData: NSData?

    /// This is the unique ID of the dream.
    var did: String
    
    /*
     Initialises a new dream.
     
     - Parameters:
     - dreamDesc: description of the user's dream.
     - dreamImg: image used for the user's dream.
     - did: unique ID of the dream.
     
     - Returns: A dream with the specified paramters.
     */
    init ( dreamDesc: String, imageURL: NSURL? = nil, imageLocalURL: NSURL? = nil, did: String, imageData: NSData? = nil )
    {
        self.dreamDesc = dreamDesc
        self.imageURL = imageURL
        self.imageLocalURL = imageLocalURL
        self.did = did
        self.imageData = imageData
    }
}