//
//  User.swift
//  NewInTown
//
//  Created by fnord on 8/1/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import Firebase

class User{
    var ownUser: FIRUser = FIRAuth.auth()!.currentUser!
    
}