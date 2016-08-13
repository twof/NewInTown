//
//  NearbyEventsViewTableController.swift
//  NewInTown
//
//  Created by fnord on 7/11/16.
//  Copyright © 2016 twof. All rights reserved.
//

import UIKit
import Alamofire
import Material

class NearbyEventsViewTableController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MaterialColor.white
        EventHelper.rangeToSearch = 10
        EventHelper.locationAddress = "738 Hayes St, San Francisco, California, United States"
        EventHelper.constructEventListWithParams({ eventList, error in
            if(error != nil){
                print(error)
            }
            
            EventHelper.eventList = eventList!
            self.tableView.reloadData()
            //print(EventHelper.eventList[0].venue.name) This breaks
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return EventHelper.eventList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCardViewCell") as! EventCardViewCell
        cell.eventNameLabel.text = EventHelper.eventList[indexPath.row].name
        
        let event = EventHelper.eventList[indexPath.row]
        
        let URLString = NSURL(string: event.imageURL)!
        cell.eventLogoImage.af_setImageWithURL(URLString)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! EventDetailViewController
        let indexPath = (self.tableView.indexPathForSelectedRow?.row)! as Int
        
        vc.event = EventHelper.eventList[indexPath]
    }

    @IBAction func unwindToEventListViewController(segue: UIStoryboardSegue){
    }
}
