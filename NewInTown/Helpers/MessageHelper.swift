//
//  MessageHelper.swift
//  NewInTown
//
//  Created by fnord on 7/22/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation

class MessageHelper {
    static func retrieveMessagesForRoom(chatRoom: ChatRoom, completion: (messages: [Message]) -> Void){
        let query = PFQuery(className: "Message")
        query.whereKey("room", equalTo: chatRoom)
        query.whereKey("createdAt", greaterThan: chatRoom.lastMessageSentDate)
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if error != nil {
                print(error)
                return
            }
            
            completion(messages: objects as! [Message])
        })
    }
}
