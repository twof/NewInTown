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
                populateUserListForRoom(foundRoom)
                completion(foundRoom)
            }
        })
    }
    
    static func addSelfToChatRoom(chatRoom: ChatRoom) {
        let currentUser = getCurrentUser()
        chatRoom.userList.append(User(email: (currentUser?.email)!, displayName: (currentUser?.displayName)!, uid: (currentUser?.uid)!))
        
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOM_DETAILS).child(chatRoom.uid as String).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if snapshot.exists() {
                snapshot.ref.child(Constants.FirebaseChatRoom.USER_LIST).child((currentUser?.uid)!).setValue(false)
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
        return FIRAuth.auth()?.currentUser
    }
    
    private static func populateUserListForRoom(chatRoom: ChatRoom){
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOM_DETAILS).child(chatRoom.uid as String).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if snapshot.exists() {
                for user in snapshot.childSnapshotForPath(Constants.FirebaseChatRoom.USER_LIST).children {
                    chatRoom.userList.append(User(email: user.value[Constants.FirebaseUser.EMAIL] as! String, displayName: user.value[Constants.FirebaseUser.USERNAME] as! String, uid: user.key))
                    
                }
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
        
        addUserToFirebase(user!)
        
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

    /*private static func uploadImageAtRef(reference: FIRDatabaseReference){
        var base64String: NSString!
        reference.
    }*/
    
    private static func addUserToFirebase(user: FIRUser){
        let usersRef = self.ref.child(Constants.FirebaseCatagories.USERS)
        let userDetailsRef = self.ref.child(Constants.FirebaseCatagories.USER_DETAILS)
        
        usersRef.queryOrderedByKey().queryEqualToValue(user.uid).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if !snapshot.exists() {
                usersRef.child(user.uid).setValue(false)
                let newUserRef = userDetailsRef.child(user.uid)
                newUserRef.child(Constants.FirebaseUser.USERNAME).setValue(user.displayName)
                newUserRef.child(Constants.FirebaseUser.EMAIL).setValue(user.email)
            }else {
                print("user already exists in database")
            }
        })
    }
    
    private static func getRefForUserId(userId: String) -> FIRDatabaseReference?{
        var refToReturn: FIRDatabaseReference!
        
        self.ref.child(Constants.FirebaseCatagories.USER_DETAILS).queryOrderedByKey().queryEqualToValue(userId).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            
            if snapshot.exists() {
                refToReturn = snapshot.ref
            }else{
                print("User does not exist")
            }
        })
        
        return refToReturn
    }
}
    
    /*private static func chatroomWithNameExists(name: String) -> Bool {
        let chatroomsRef = self.ref.child(Constants.FirebaseCatagories.CHAT_ROOM_DETAILS)
        
        chatroomsRef.observeSingleEventOfType(.Value, withBlock: )
    }*/
