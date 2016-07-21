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
        loadEventImage(EventHelper.eventList[indexPath.row].imageURL, imageViewToSet: (cell?.eventLogoImage)!)
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! EventDetailViewController
        let indexPath = (self.tableView.indexPathForSelectedRow?.row)! as Int
        
        vc.event = EventHelper.eventList[indexPath]
    }
    
    func loadEventImage(urlString: String, imageViewToSet: UIImageView){
        Alamofire.request(.GET, urlString)
            .responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    let size = CGSize(width: imageViewToSet.frame.width, height: imageViewToSet.frame.height)
                    let aspectScaledToFitImage = image.af_imageAspectScaledToFitSize(size)
                    imageViewToSet.image = aspectScaledToFitImage
                }
        }
    }
    
    
    @IBAction func unwindToEventListViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }

}
