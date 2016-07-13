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
        })
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(EventHelper.eventList.count)
        return EventHelper.eventList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCardViewCell") as? EventCardViewCell
        cell?.eventNameLabel.text = EventHelper.eventList[indexPath.row].name
        
        return cell!
    }
    

}
