//
//  LoginViewController.swift
//  NewInTown
//
//  Created by fnord on 8/1/16.
//  Copyright © 2016 twof. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper.initializeFirebaseHelper()
        //self.view.backgroundColor = UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTouchLoginButton(sender: UIButton) {
        // Sign In with credentials.
        let email = "fabiobean2@gmail.com"
        let password = "password"
        FirebaseHelper.signInWithEmail(email, password: password, sender: self)
    }
    
    @IBAction func didTouchSignUpButton(sender: UIButton) {
        let email = "fabiobean2@gmail.com"
        let password = "password"
        FirebaseHelper.createNewUserWithEmail(email, password: password, sender: self)
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
