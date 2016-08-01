//
//  FirebaseHelper.swift
//  NewInTown
//
//  Created by fnord on 8/1/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseHelper {
    static private var ref: FIRDatabaseReference!
    
    static func getMessagesForRoom(chatroom: ChatRoom){
        
    }
    
    static func initializeChatRoom(name: String, completion: (ChatRoom) -> Void){
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if !snapshot.hasChild(name) {
                let chatRoom = ChatRoom(name: name)
                self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).setValue(chatRoom)
                completion(chatRoom)
            }else{
                completion(snapshot.childSnapshotForPath(name).value as! ChatRoom)
            }
        })
    }
    
    static func addUserToChatRoom(user: User, chatRoom: ChatRoom) {
        chatRoom.userList.append(user)
        
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).child(chatRoom.name!).child(Constants.FirebaseChatRoom.USER_LIST).setValue(chatRoom.userList)
    }
    
    static func sendMessageToChatRoom(message: Message, chatRoom: ChatRoom){
        
    }
    
}