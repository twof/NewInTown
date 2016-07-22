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