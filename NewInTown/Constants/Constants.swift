//
//  Constants.swift
//  NewInTown
//
//  Created by fnord on 8/1/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation

struct Constants {
    static let SPTClientID = "ce663ece19f84a358ba4d66a9a446dcc"
    static let partyIdKey = "partyId"
    
    
    struct FirebaseCatagories {
        static let USERS = "users"
        static let CHAT_ROOMS = "chatrooms"
        static let MESSAGES = "messages"
    }
    
    struct FirebaseUser {
        static let USERNAME = "username"
        static let PASSWORD = "password"
        static let EMAIL = "email"
    }
    
    struct FirebaseChatRoom {
        static let NAME = "name"
        static let USER_LIST = "userList"
    }
    
    struct FirebaseMessage {
        static let BODY = "body"
        static let SENDER = "sender"
        static let ROOM = "room"
    }
}