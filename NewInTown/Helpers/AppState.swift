//
//  AppState.swift
//  NewInTown
//
//  Created by fnord on 8/4/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoUrl: NSURL?
}
