//
//  EventHelper.swift
//  NewInTown
//
//  Created by fnord on 7/12/16.
//  Copyright © 2016 twof. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class EventHelper {
    
    static var locationAddress: String!
    static var rangeToSearch: Int!
    static var eventList = [Event]()
    private static let token = EVENTBRIGHT_PRIVATE_KEY
    
    
    static func constructEventListWithParams(completionHandler: ([Event]?, NSError?) -> ()){
        let urlToGet = constructEventsAPIURL()
        Alamofire.request(.GET, urlToGet).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let eventListJson = json["events"].arrayValue
                    
                    
                    for x in eventListJson{
                        eventList.append(Event(json: x))
                    }
                    completionHandler(eventList, nil)
                }
            case .Failure(let error):
                print(error)
                completionHandler(nil, error)
            }
        }
    }
    
    static func getEventVenueForVenueId(venueId: String, completionHandler: (Venue?, NSError?) -> ()){
        let urlToGet = constructEventsAPIURL()
        Alamofire.request(.GET, urlToGet).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    completionHandler(Venue(json: json), nil)
                }
            case .Failure(let error):
                print(error)
                completionHandler(nil, error)
            }
        }
    }
    
    
    private static func constructEventsAPIURL() -> String{
        let url = "https://www.eventbriteapi.com/v3/events/search/?token=\(token)&location.address=\(locationAddress)&location.within=\(rangeToSearch)mi"
        
        return url.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}