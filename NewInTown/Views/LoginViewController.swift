//
//  LoginViewController.swift
//  NewInTown
//
//  Created by fnord on 8/1/16.
//  Copyright © 2016 twof. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper.initializeFirebaseHelper()
        //self.view.backgroundColor = UIColor.redColor()
    }

    @IBAction func didTouchLoginButton(sender: UIButton) {
        // Sign In with credentials.
        let email = emailField.text
        let password = passwordField.text
        FirebaseHelper.signInWithEmail(email!, password: password!, sender: self, completion: {(error) in
            self.errorLabel.text = error?.localizedDescription
        })
    }
    
    @IBAction func didTouchSignUpButton(sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        FirebaseHelper.createNewUserWithEmail(email!, password: password!, sender: self)
    }


}
