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

class Message {
    
    var body: String?
    var sender: User!
    var room: ChatRoom!
    var uid: String!
    
    init(body: String, sender: User, room: ChatRoom) {
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