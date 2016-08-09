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
    
    static func initializeChatRoom(name: String, completion: (ChatRoom) -> Void){
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if !snapshot.hasChild(name) {
                let roomRef = self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).childByAutoId()
                let roomDetailsRef = self.ref.child(Constants.FirebaseCatagories.CHAT_ROOM_DETAILS).child(roomRef.key)
                
                let chatRoom = ChatRoom(name: name, uid: roomRef.key)
                
                roomRef.setValue(true)
                roomDetailsRef.child(Constants.FirebaseChatRoom.IS_ACTIVE).setValue(true)
                roomDetailsRef.child(Constants.FirebaseChatRoom.NAME).setValue(chatRoom.name)
                roomDetailsRef.child(Constants.FirebaseChatRoom.USER_LIST).setValue([])
                
                completion(chatRoom)
            }else{
                completion(snapshot.childSnapshotForPath(name).value as! ChatRoom)
            }
        })
    }
    
    static func addSelfToChatRoom(chatRoom: ChatRoom) {
        chatRoom.userList.append(FIRAuth.auth()?.currentUser as! User)
        
        self.ref.child(Constants.FirebaseCatagories.CHAT_ROOMS).child(chatRoom.uid as String).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if snapshot.exists() {
                snapshot.ref.child(Constants.FirebaseChatRoom.USER_LIST).child((FIRAuth.auth()?.currentUser?.uid)!).setValue(false)
            }else{
                print("user not added to room")
            }
        })
    }
    
    static func uploadMessage(message: Message){
        let newMessageRef = self.ref.child(Constants.FirebaseCatagories.MESSAGES).childByAutoId()
        
        newMessageRef.setValue(message)
    }
    
    static func configureDatabaseForRoom(chatRoom: ChatRoom) {
    }
    
    static func getCurrentUser() -> User {
        return FIRAuth.auth()?.currentUser as! User
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
            self.signedIn(FIRAuth.auth()?.currentUser, sender: sender)
        }
    }
}