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
        self.ref.child(Constants.FirebaseCatagories.MESSAGES).queryOrderedByChild(Constants.FirebaseMessage.ROOM).queryEqualToValue(chatroom.name).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            
            chatroom.messageList = snapshot.children.allObjects as! [Message]
        })
    }
    
    static func initializeChatRoom(name: String, completion: (ChatRoom) -> Void){
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if !snapshot.hasChild(name) {
                let chatRoom = ChatRoom(name: name)
                self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).childByAutoId()
                completion(chatRoom)
            }else{
                completion(snapshot.childSnapshotForPath(name).value as! ChatRoom)
            }
        })
    }
    
    static func addUserToChatRoom(user: User, chatRoom: ChatRoom) {
        chatRoom.userList.append(user)
        let newUserRef
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).child(chatRoom.name!).child(Constants.FirebaseChatRoom.USER_LIST).setValue(chatRoom.userList)
    }
    
    static func uploadMessage(message: Message){
        let newMessageRef = self.ref.child(Constants.FirebaseCatagories.MESSAGES).childByAutoId()
        
        newMessageRef.setValue(message)
    }
    
}