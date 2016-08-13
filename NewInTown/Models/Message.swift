//
//  Message.swift
//  NewInTown
//
//  Created by fnord on 7/22/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import Firebase
import CryptoSwift

class Message: NSObject {
    
    var body: NSString!
    var sender: User!
    var room: ChatRoom!
    var createdAt: NSDate!
    var uid: NSString!
    
    init(body: String, sender: User, room: ChatRoom) {
        super.init()
        self.body = body
        self.sender = sender
        self.room = room
    }
    
    init(messageSnapshot: FIRDataSnapshot, userSnapshot: FIRDataSnapshot, room: ChatRoom) {
        super.init()
        
        self.body = messageSnapshot.value!.objectForKey(Constants.FirebaseMessage.BODY) as! String
        self.room = room
        self.sender = User(email: (userSnapshot.value?.objectForKey(Constants.FirebaseUser.EMAIL))! as! String , displayName: (userSnapshot.value?.objectForKey(Constants.FirebaseUser.USERNAME))! as! String, uid: userSnapshot.key)
        
        /*FirebaseHelper.getRefForUserId(messageSnapshot.childSnapshotForPath(Constants.FirebaseMessage.SENDER).value as! String, completion: {(userRef) in
            userRef?.observeSingleEventOfType(.Value, withBlock: {(userSnapshot) in
                self.sender = User(snapshot: userSnapshot)
            })
        })*/
    }
}

extension Message: JSQMessageData{
    @objc func senderId() -> String! {
        return sender.uid as String
    }
    
    @objc func senderDisplayName() -> String! {
        return sender.displayName! as String
    }
    
    @objc func date() -> NSDate! {
        return self.createdAt
    }
    
    @objc func isMediaMessage() -> Bool {
        return false
    }
    
    @objc func text() -> String! {
        return body as String
    }
    
    @objc func messageHash() -> UInt{
        let hashStringSeed: String = (body! as String)+(sender.uid)+(room.uid! as String)
        let md5hash = hashStringSeed.md5().uppercaseString
        let index = md5hash.endIndex.advancedBy(-24)
        let shortermd5hash = md5hash.substringToIndex(index)
        let intToReturn = UInt(shortermd5hash, radix: 16)
        return intToReturn!
    }
}