//
//  Message.swift
//  NewInTown
//
//  Created by fnord on 7/22/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import CryptoSwift

class Message: {
    
    @NSManaged var body: String?
    @NSManaged var sender: PFUser!
    @NSManaged var room: ChatRoom!
    
    
    
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "Message"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    init(body: String, sender: PFUser, room: ChatRoom) {
        super.init()
        self.body = body
        self.sender = sender
        self.room = room
        //Add message to it's respective
        uploadMessage()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    func uploadMessage() {
        self.saveInBackground()
    }
}

extension Message: JSQMessageData{
    func senderId() -> String! {
        return sender.objectId
    }
    
    func senderDisplayName() -> String! {
        do{
            return try sender.fetchIfNeeded().username
        }catch{
            print(error)
            return ""
        }
    }
    
    func date() -> NSDate! {
        return self.createdAt
    }
    
    func isMediaMessage() -> Bool {
        return false
    }
    
    func text() -> String! {
        return body
    }
    
    func messageHash() -> UInt{
        let hashStringSeed: String = body!+sender.objectId!+room.objectId!
        let md5hash = hashStringSeed.md5().uppercaseString
        let index = md5hash.endIndex.advancedBy(-24)
        let shortermd5hash = md5hash.substringToIndex(index)
        let intToReturn = UInt(shortermd5hash, radix: 16)
        return intToReturn!
    }
}