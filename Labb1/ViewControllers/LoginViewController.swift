//
//  LoginViewController.swift
//  Labb1
//
//  Created by Jonatan Bengtsson on 2019-03-13.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginButtonOutlet.backgroundColor = UIColor .flatGray()
        navigationItem.title = "Login"
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        loginButtonOutlet.isEnabled = false
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            if error != nil {
                print(error!)
            }
            else {
                if Auth.auth().currentUser != nil {
                    // User is signed in.
                    print("Login successful!")
                    self.performSegue(withIdentifier: "goToTasks", sender: self)
                } else {
                    // No user is signed in.
                    print("Something went wrong, user is not signed in!")
                }
            }
            SVProgressHUD.dismiss()
            self.loginButtonOutlet.isEnabled = true
        }
    }
}
