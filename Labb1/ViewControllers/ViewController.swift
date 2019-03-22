//
//  ViewController.swift
//  Labb1
//
//  Created by Jonatan Bengtsson on 2019-03-11.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginButtonOutlet.backgroundColor = UIColor .flatGray()
        registerButtonOutlet.backgroundColor = UIColor .flatNavyBlue()
        
        navigationItem.title = "Welcome"
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLoginView", sender: self)
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegisterView", sender: self)
    }
    
}

