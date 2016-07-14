//
//  Venue.swift
//  NewInTown
//
//  Created by fnord on 7/14/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Venue{
    let address: String
    let city: String
    var region: String
    let postalCode: String
    let country: String
    let name: String
    let latitude: String
    let longitude: String
    
    init(json: JSON) {
        self.address = json["address"]["address_1"].stringValue
        self.city = json["address"]["city"].stringValue
        self.region = json["address"]["region"].stringValue
        self.postalCode = json["address"]["postal_code"].stringValue
        self.country = json["address"]["country"].stringValue
        self.name = json["name"].stringValue
        self.latitude = json["address"]["latitude"].stringValue
        self.longitude = json["address"]["longitude"].stringValue
    }
}