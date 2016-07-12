//
//  Event.swift
//  NewInTown
//
//  Created by fnord on 7/12/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Event {
    let name: String
    let description: String
    var price: Double!
    let link: String
    let startTime: String
    let endTime: String
    let eventID: String
    let imageURL: String
    
    init(json: JSON) {
        self.name = json["name"]["text"].stringValue
        self.description = json["description"]["text"].stringValue
        self.link = json["url"].stringValue
        self.startTime = json["start"]["local"].stringValue
        self.endTime = json["end"]["local"].stringValue
        self.eventID = json["id"].stringValue
        self.imageURL = json["logo"]["url"].stringValue
    }
}