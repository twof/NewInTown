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
    static var venueList = [Venue]()
    private static let token = EVENTBRIGHT_PRIVATE_KEY
    private static var venueCompletionCounter = 0
    
    
    static func constructEventListWithParams(completionHandler: ([Event]?, NSError?) -> ()){
        let urlToGet = constructEventsAPIURL()
        Alamofire.request(.GET, urlToGet).validate().responseJSON() { response in
            print("NETWORK CALL FINISHED")
            
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let eventListJson = json["events"].arrayValue
                    var allEventsList = [Event]()
                    for index in 0 ... eventListJson.count - 1 {
                        
                        allEventsList.append(Event(json: eventListJson[index],
                            venue: Venue(json: eventListJson[index]["venue"])))
                    }
                    
                    completionHandler(allEventsList, nil)
                }
            case .Failure(let error):
                print(error)
                completionHandler(nil, error)
            }
        }
    }
    
    static func getEventWithEventId(eventId: String) -> Event?{
        var eventToReturn: Event!
        for event in eventList {
            if event.eventID == eventId {
                eventToReturn = event
            }
        }
        return eventToReturn
    }
    
    
    private static func constructEventsAPIURL() -> String{
        let url = "https://www.eventbriteapi.com/v3/events/search/?token=\(token)&location.address=\(locationAddress)&location.within=\(rangeToSearch)mi&expand=venue&sort_by=date"
        
        return url.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}