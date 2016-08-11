//
//  ChatRoom.swift
//  NewInTown
//
//  Created by fnord on 7/21/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import Firebase

class ChatRoom {
    
    var event: Event!
    var userList: [User]!
    var messageList = [Message]()
    var lastMessageSentDate = NSDate.init(timeIntervalSince1970: 0)
    var uid: NSString!
    
    init(event: Event) {
        self.event = event
        self.uid = event.eventID
        userList = []
        messageList = []
    }
}
