//
//  LoginViewController.swift
//  NewInTown
//
//  Created by fnord on 8/1/16.
//  Copyright © 2016 twof. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    // MARK: Properties
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchToLogin(sender: AnyObject?){
        // Sign In with credentials.
        let email = "fabiobean2@gmail.com"
        let password = "password"
        FirebaseHelper.signInWithEmail(email, password: password)
    }
    
    @IBAction func didTouchSignUp(sender: AnyObject?){
        let email = "fabiobean2@gmail.com"
        let password = "password"
        FirebaseHelper.createNewUserWithEmail(email, password: password)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
