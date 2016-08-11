//
//  Constants.swift
//  NewInTown
//
//  Created by fnord on 8/1/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation

struct Constants {
    
    struct FirebaseCatagories {
        static let USERS = "Users"
        static let USER_DETAILS = "UserDetails"
        
        static let CHAT_ROOMS = "ChatRooms"
        static let CHAT_ROOM_DETAILS = "ChatRoomDetails"
        static let MESSAGES = "Messages"
    }
    
    
    struct FirebaseUser {
        static let USERNAME = "userName"
        static let EMAIL = "email"
    }
    
    struct FirebaseChatRoom {
        static let IS_ACTIVE = "isActive"
        static let NAME = "name"
        static let USER_LIST = "userList"
    }
    
    struct FirebaseMessage {
        static let BODY = "body"
        static let SENDER = "sender"
    }
}