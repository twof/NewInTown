//
//  FirebaseHelper.swift
//  NewInTown
//
//  Created by fnord on 8/1/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class FirebaseHelper {
    static private var ref: FIRDatabaseReference!
    static private var _refHandle: FIRDatabaseHandle!
    
    static func initializeFirebaseHelper(){
        self.ref = FIRDatabase.database().reference()

    }
    
    //Call this in the completion callback of initializeChatRoom
    static func listenForNewMessagesInRoom(chatRoom: ChatRoom){
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child(Constants.FirebaseCatagories.MESSAGES).queryOrderedByKey().queryEqualToValue(chatRoom.uid).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            
            chatRoom.messageList.append(snapshot.value as! Message)
        })
    }
    
    static func initializeChatRoom(event: Event, completion: (ChatRoom) -> Void){
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if !snapshot.exists() {

                let roomRef = self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).child(event.eventID)
                let roomDetailsRef = self.ref.child(Constants.FirebaseCatagories.CHAT_ROOM_DETAILS).child(roomRef.key)
                
                let chatRoom = ChatRoom(event: event)
                
                roomRef.setValue(true)
                roomDetailsRef.child(Constants.FirebaseChatRoom.IS_ACTIVE).setValue(true)
                roomDetailsRef.child(Constants.FirebaseChatRoom.NAME).setValue(chatRoom.event.name)
                roomDetailsRef.child(Constants.FirebaseChatRoom.USER_LIST).setValue([])
                
                completion(chatRoom)
            }else{
                let foundRoom = ChatRoom(event: event)
                foundRoom
                completion()
            }
        })
    }
    
    static func addSelfToChatRoom(chatRoom: ChatRoom) {
        chatRoom.userList.append(getCurrentUser())
        
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOM_DETAILS).child(chatRoom.uid as String).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if snapshot.exists() {
                snapshot.ref.child(Constants.FirebaseChatRoom.USER_LIST).child(getCurrentUser().uid).setValue(false)
            }else{
                print("user not added to room")
            }
        })
    }
    
    static func uploadMessage(message: Message){
        var newMessageRef = self.ref.child(Constants.FirebaseCatagories.MESSAGES).child(message.room.uid as String)
       
        newMessageRef.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if snapshot.exists() {
                newMessageRef = snapshot.ref.childByAutoId()
                message.uid = newMessageRef.key
                newMessageRef.child(Constants.FirebaseMessage.BODY).setValue(message.body)
                newMessageRef.child(Constants.FirebaseMessage.SENDER).setValue(message.sender.uid)
            }
        })
    }
    
    static func getCurrentUser() -> FIRUser? {
        var userToReturn: FIRUser
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                userToReturn = user
            } else {
                print("No user signed in currently")
            }
        }
        
        return userToReturn
    }
    
    private static func populateUserListForRoom(chatRoom: ChatRoom){
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOM_DETAILS).child(chatRoom.uid as String).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if snapshot.exists() {
                chatRoom.userList = snapshot.childSnapshotForPath(Constants.FirebaseChatRoom.USER_LIST)
                FIRAuth.
            }else{
                print("Couldn't find room to populate userlist. Something went very wrong because this should never happen")
            }
        })
    }
    
    private static func getRefForChatRoom(chatRoom: ChatRoom) -> FIRDatabaseReference? {
        return nil
    }
    
    static func signInWithEmail(email: String, password: String, sender: UIViewController){
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.signedIn(user!, sender: sender)
        }
    }
    
    static func createNewUserWithEmail(email: String, password: String, sender: UIViewController){
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.setDisplayName(user!, sender: sender)
        }
        
        
    }
    
    private static func signedIn(user: FIRUser?, sender: UIViewController) {
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoUrl = user?.photoURL
        AppState.sharedInstance.signedIn = true
        
        sender.performSegueWithIdentifier("ToEventListViewController", sender: sender)
    }
    
    private static func setDisplayName(user: FIRUser, sender: UIViewController) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.componentsSeparatedByString("@")[0]
        changeRequest.commitChangesWithCompletion(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.signedIn(getCurrentUser(), sender: sender)
        }
    }
    
    private static func addUserToFirebase
    
    /*private static func chatroomWithNameExists(name: String) -> Bool {
        let chatroomsRef = self.ref.child(Constants.FirebaseCatagories.CHAT_ROOM_DETAILS)
        
        chatroomsRef.observeSingleEventOfType(.Value, withBlock: <#T##(FIRDataSnapshot) -> Void#>)
    }*/
}