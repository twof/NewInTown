//
//  EventDetailViewController.swift
//  NewInTown
//
//  Created by fnord on 7/13/16.
//  Copyright © 2016 twof. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDateAndTime: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = event.name
        eventDescription.text = event.description
        eventDateAndTime.text = event.startTime
        eventTitle.text = event.name
        eventLocation.text = event.venue.name
        loadEventImage(event.imageURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loadEventImage(urlString: String){
        Alamofire.request(.GET, urlString)
            .responseImage { response in
                
                if let image = response.result.value {
                    let size = CGSize(width: self.eventImageView.frame.width, height: self.eventImageView.frame.height)
                    let aspectScaledToFitImage = image.af_imageAspectScaledToFitSize(size)
                    self.eventImageView.image = aspectScaledToFitImage
                }
        }
    }
    
    @IBAction func backToEventList(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("ToEventListController", sender: self)
    }
    
    @IBAction func unwindToEventDetailViewController(segue: UIStoryboardSegue) {}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let embeddedVC = segue.destinationViewController as? ChatRoomViewController where segue.identifier == "ToChatRoom" {
            embeddedVC.event = event
        }
    }
}
