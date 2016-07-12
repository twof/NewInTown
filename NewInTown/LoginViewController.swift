//
//  LoginViewController.swift
//  NewInTown
//
//  Created by fnord on 7/11/16.
//  Copyright © 2016 twof. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController, TextFieldDelegate{

    @IBOutlet weak var loginButton: FlatButton!
    @IBOutlet weak var usernameField: TextField!
    @IBOutlet weak var passwordField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareNameField()
        preparePasswordField()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareNameField() {
        usernameField.placeholder = "Username"
    }
    
    /// Prepares the email TextField.
    private func preparePasswordField() {
        passwordField.placeholder = "Password"
        passwordField.delegate = self
        
        /*
         Used to display the error message, which is displayed when
         the user presses the 'return' key.
         */
        passwordField.detail = "Email is incorrect."
    }
    
    func prepareFlatButtonExample() {
        loginButton.setTitle("Flat", forState: .Normal)
        loginButton.titleLabel!.font = RobotoFont.mediumWithSize(32)
    }
    
    /// Executed when the 'return' key is pressed when using the emailField.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return false
    }
}
