//
//  FirebaseHelper.swift
//  NewInTown
//
//  Created by fnord on 8/1/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

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
    
    static func addSelfToChatRoom(chatRoom: ChatRoom) {
        chatRoom.userList.append(FIRAuth.auth()?.currentUser as! User)
        let newUserRef = self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).child(chatRoom.uid as String)
        
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).child(chatRoom.name! as String).child(Constants.FirebaseChatRoom.USER_LIST).setValue(chatRoom.userList) //TODO: probably can't append an entire userlist
    }
    
    static func uploadMessage(message: Message){
        let newMessageRef = self.ref.child(Constants.FirebaseCatagories.MESSAGES).childByAutoId()
        
        newMessageRef.setValue(message)
    }
    
    static func configureDatabase() {
        self.ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.messages.append(snapshot)
            self.clientTable.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messages.count-1, inSection: 0)], withRowAnimation: .Automatic)
        })
    }
    
    static func getCurrentUser() -> User {
        return FIRAuth.auth()?.currentUser as! User
    }
    
}