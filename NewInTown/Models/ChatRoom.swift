//
//  ChatRoom.swift
//  NewInTown
//
//  Created by fnord on 7/21/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation

class ChatRoom {
    
    var name: String?
    var userList: [User]!
    var messageList = [Message]()
    var lastMessageSentDate = NSDate.init(timeIntervalSince1970: 0)
    
    
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "ChatRoom"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    init(name: String) {
        super.init()
        self.name = name
        userList = []
        messageList = []
        uploadChatRoom()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    func uploadChatRoom() {
        self.saveInBackground()
    }
}
