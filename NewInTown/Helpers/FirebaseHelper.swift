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
import JSQMessagesViewController

class FirebaseHelper {
    static private var ref: FIRDatabaseReference!
    static private var _refHandle: FIRDatabaseHandle!
    static var senderCounter = 0
    
    static func initializeFirebaseHelper(){
        self.ref = FIRDatabase.database().reference()
        
    }
    
    //Call this in the completion callback of initializeChatRoom
    static func listenForNewMessagesInRoom(chatRoom: ChatRoom, messageCallback: (Message) -> Void){
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child(Constants.FirebaseCatagories.MESSAGES).child(chatRoom.uid as String).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            
            self.ref.child(Constants.FirebaseCatagories.USER_DETAILS).child(snapshot.childSnapshotForPath(Constants.FirebaseMessage.SENDER).value as! String).observeSingleEventOfType(.Value, withBlock: {(userSnapshot) in
              
                messageCallback(Message(messageSnapshot: snapshot, userSnapshot: userSnapshot, room: chatRoom))
            })
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
                completion(foundRoom)
            }
        })
    }
    
    static func addSelfToChatRoom(chatRoom: ChatRoom) {
        let currentUser = getCurrentFirebaseUser()
        //chatRoom.userList.append(User(email: (currentUser?.email)!, displayName: (currentUser?.displayName)!, uid: (currentUser?.uid)!))
        
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOM_DETAILS).child(chatRoom.uid as String).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if snapshot.exists() {
                snapshot.ref.child(Constants.FirebaseChatRoom.USER_LIST).child((currentUser!.uid)).setValue(false)
            }else{
                print("user not added to room")
            }
        })
    }
    
    static func uploadMessage(message: Message){
        let roomRef = self.ref.child(Constants.FirebaseCatagories.MESSAGES).child(message.room.uid as String)
        
        let messageRef = roomRef.childByAutoId()
        
        messageRef.setValue([Constants.FirebaseMessage.BODY: message.body, Constants.FirebaseMessage.SENDER: message.sender.uid])
    }
    
    static func getCurrentFirebaseUser() -> FIRUser? {
        return FIRAuth.auth()?.currentUser
    }

    static func getCurrentUser() -> User {
        return User(firUser: (FIRAuth.auth()?.currentUser)!)
    }
    
    static func populateUserListForRoom(chatRoom: ChatRoom, completion: ([User]) -> Void){
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOM_DETAILS).child(chatRoom.uid as String).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            var userList = [User]()
            for user in snapshot.childSnapshotForPath(Constants.FirebaseChatRoom.USER_LIST).children {
                
                userList.append(User(snapshot: user as! FIRDataSnapshot, completion: {() in
                    
                }))
            }
            completion(userList)
        })
    }
    
    static func populateMessagesForRoom(chatRoom: ChatRoom, completion: ([Message]) -> Void){
        
        self.ref.child(Constants.FirebaseCatagories.MESSAGES).child(chatRoom.uid as String).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
           
            for message in snapshot.children {
                
                self.ref.child(Constants.FirebaseCatagories.USER_DETAILS).child(message.childSnapshotForPath(Constants.FirebaseMessage.SENDER).value as! String).observeSingleEventOfType(.ChildAdded, withBlock: {(userSnapshot) in
                
                    chatRoom.messageList.append(Message(messageSnapshot: message as! FIRDataSnapshot, userSnapshot: userSnapshot, room: chatRoom))
            
                })
            }
        })
    }
    
    // MARK: - 1
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
    // MARK: - 2
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
            self.signedIn(getCurrentFirebaseUser(), sender: sender)
        }
    }
    
    /*private static func uploadImageAtRef(reference: FIRDatabaseReference){
     var base64String: NSString!
     reference.
     }*/
    // MARK: - 3
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
    
    static func getRefForUserId(userId: String, completion: (FIRDatabaseReference?) -> Void){
        
        self.ref.child(Constants.FirebaseCatagories.USER_DETAILS).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            
            if snapshot.childSnapshotForPath(userId).exists() {
                completion(snapshot.childSnapshotForPath(userId).ref)
            }else{
                print("User does not exist")
                completion(nil)
            }
        })
    }
}

/*private static func chatroomWithNameExists(name: String) -> Bool {
 let chatroomsRef = self.ref.child(Constants.FirebaseCatagories.CHAT_ROOM_DETAILS)
 
 chatroomsRef.observeSingleEventOfType(.Value, withBlock: )
 }*/
