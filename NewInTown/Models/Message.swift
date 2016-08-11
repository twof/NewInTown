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
    
    var body: NSString?
    var sender: FIRUser!
    var room: ChatRoom!
    var createdAt: NSDate!
    var uid: NSString!
    
    init(body: String, sender: FIRUser, room: ChatRoom) {
        super.init()
        self.body = body
        self.sender = sender
        self.room = room
        //Add message to it's respective
        uploadMessage()
    }
    
    func uploadMessage() {
        FirebaseHelper.uploadMessage(self)
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
        return body as! String
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