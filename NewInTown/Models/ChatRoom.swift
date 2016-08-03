//
//  ChatRoom.swift
//  NewInTown
//
//  Created by fnord on 7/21/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation

class ChatRoom {
    
    var name: NSString?
    var userList: [User]!
    var messageList = [Message]()
    var lastMessageSentDate = NSDate.init(timeIntervalSince1970: 0)
    var uid: NSString!
    
    
    
    init(name: String) {
        self.name = name
        userList = []
        messageList = []
    }
}
