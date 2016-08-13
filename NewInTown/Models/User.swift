//
//  User.swift
//  NewInTown
//
//  Created by fnord on 8/1/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import Firebase
import AlamofireImage

class User{
    var email: String!
    var displayName: String!
    var photoURL: NSURL!
    var photo: UIImage!
    var uid: String!
    
    init(firUser: FIRUser){
        self.email = firUser.email
        self.displayName = firUser.displayName
        self.photoURL = firUser.photoURL
        self.uid = firUser.uid
    }
    
    init(snapshot: FIRDataSnapshot, completion: (Void) -> Void){
        FirebaseHelper.getRefForUserId(snapshot.key, completion: {(userRef) in
            userRef?.observeSingleEventOfType(.Value, withBlock: {(userSnapshot) in
                self.email = userSnapshot.value!.objectForKey(Constants.FirebaseUser.EMAIL) as! String
                self.displayName = userSnapshot.value!.objectForKey(Constants.FirebaseUser.USERNAME) as! String
                self.uid = userSnapshot.key
                completion()
            })
        })
    }
    
    init(email: String, displayName: String, /*photoURL: String,*/ uid: String) {
        self.email = email
        self.displayName = displayName
        self.uid = uid
        
        //self.photoURL = NSURL(fileReferenceLiteral: photoURL)
    }
}