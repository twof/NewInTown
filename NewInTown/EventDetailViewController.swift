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
        eventDescription.text = event.description
        eventDateAndTime.text = event.startTime
        eventTitle.text = event.name
        loadEventImage(event.imageURL)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadEventImage(urlString: String){
        Alamofire.request(.GET, urlString)
            .responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    let size = CGSize(width: self.eventImageView.frame.width, height: self.eventImageView.frame.height)
                    let aspectScaledToFitImage = image.af_imageAspectScaledToFitSize(size)
                    self.eventImageView.image = aspectScaledToFitImage
                }
        }
    }
}
