//
//  ParseHelper.swift
//  NewInTown
//
//  Created by fnord on 7/21/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    static private var runningParseListeners = [NSBlockOperation]()
    static private var parseListenerQueue = NSOperationQueue()
    
    static func startParseListeners(){
        while true {
            for operation in runningParseListeners {
                parseListenerQueue.addOperation(operation)
            }
        }
    }
    
    static func addNewParseListeners(chatRoom: ChatRoom){
        let operation = NSBlockOperation(block: {
            MessageHelper.retrieveMessagesForRoom(chatRoom, completion: {(messages) in
                chatRoom.messageList += messages as [Message]
                
                chatRoom.lastMessageSentDate = chatRoom.messageList[chatRoom.messageList.count-1].createdAt!
            })
        })
        operation.name = chatRoom.name
        runningParseListeners.append(operation)
    }
    
    static func removeParseListener(chatRoom: ChatRoom){
        for operation in runningParseListeners {
            if operation.name == chatRoom.name {
                runningParseListeners.removeAtIndex(runningParseListeners.indexOf(operation)!)
            }
        }
    }
    
    static func initializeChatRoom(name: String, completion: (chatroom: ChatRoom) -> Void){
        
        
        let query = PFQuery(className: "ChatRoom")
        query.whereKey("name", equalTo: name)
        
        query.countObjectsInBackgroundWithBlock({(count, error) in
            if error != nil {
                print(error)
                return
            }
            
            if count > 0 {
                query.getFirstObjectInBackgroundWithBlock({(object, error) in
                    completion(chatroom: object as! ChatRoom)
                })
            }else{
                completion(chatroom: ChatRoom(name: name))
            }
        })
    }
    
    static func addUserToChatRoom(user: PFUser, name: String){
        let query = PFQuery(className: "ChatRoom")
        query.whereKey("name", equalTo: name)
        
        query.getFirstObjectInBackgroundWithBlock({(object, error) in
            if error != nil {
                print(error)
                return
            }
            
            var chatRoomToCheckUserList = (object as! ChatRoom).userList
            
            if ((chatRoomToCheckUserList).contains({$0.objectId == user.objectId})){
                return
            }else{
                chatRoomToCheckUserList.append(user)
                object?.setValue(chatRoomToCheckUserList, forKey: "userList")
                object?.saveInBackground()
            }
        })
    }
}