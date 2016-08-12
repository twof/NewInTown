//
//  ChatRoomViewConroller.swift
//  NewInTown
//
//  Created by fnord on 7/21/16.
//  Copyright © 2016 twof. All rights reserved.
//
import UIKit
import JSQMessagesViewController
import Firebase

class ChatRoomViewController: JSQMessagesViewController {
    var event: Event!
    var chatRoom: ChatRoom!
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper.initializeChatRoom(event, completion: {(newChatRoom) in
            self.chatRoom = newChatRoom
            FirebaseHelper.addSelfToChatRoom(self.chatRoom)
            FirebaseHelper.listenForNewMessagesInRoom(self.chatRoom)
            
            //Adding a nav bar
            let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 44))
            self.view.addSubview(navBar);
            let navItem = UINavigationItem(title: self.chatRoom.event.name as String);
            let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: nil, action: #selector(ChatRoomViewController.backToDetailViewController));
            navItem.rightBarButtonItem = doneItem;
            navBar.setItems([navItem], animated: false);
            
        })
        self.setup()
    }
    
    override func viewWillDisappear(animated: Bool) {
        //TODO: Remove Firebase observers
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
}

//MARK - Setup
extension ChatRoomViewController {
    func setup() {
        self.senderId = FirebaseHelper.getCurrentFirebaseUser()!.uid
        self.senderDisplayName = FirebaseHelper.getCurrentFirebaseUser()!.displayName
    }
}

//MARK - Data Source
extension ChatRoomViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isNil = self.chatRoom == nil
        return isNil ? 0 : self.chatRoom.messageList.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.chatRoom.messageList[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.chatRoom.messageList.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = self.chatRoom.messageList[indexPath.row]
        switch(data.sender.uid) {
            case (FirebaseHelper.getCurrentFirebaseUser()!.uid):
                return self.outgoingBubble
            default:
                return self.incomingBubble
            }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    func backToDetailViewController(){
        self.performSegueWithIdentifier("UnwindToEventDetailViewController", sender: self)
    }
}

extension ChatRoomViewController {
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let newMessage = Message(body: text, sender: FirebaseHelper.getCurrentFirebaseUser()! , room: chatRoom)
        self.chatRoom.messageList.append(newMessage)
        FirebaseHelper.uploadMessage(newMessage)
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
    }
}

func ==(left: FIRUser, right: FIRUser) -> Bool {
    return left.uid == right.uid
}