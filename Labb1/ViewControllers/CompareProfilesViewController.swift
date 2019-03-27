//
//  CompareProfilesViewController.swift
//  Labb1
//
//  Created by Jonatan Bengtsson on 2019-03-17.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit
import ChameleonFramework

class CompareProfilesViewController: UIViewController {

    @IBOutlet weak var currentUserNameLabel: UILabel!
    @IBOutlet weak var currentUserPointsLabel: UILabel!
    
    @IBOutlet weak var userToCompareNameLabel: UILabel!
    @IBOutlet weak var userToComparePointsLabel: UILabel!
    
    @IBOutlet weak var topInnerContainerView: UIView!
    @IBOutlet weak var bottomInnerContainerView: UIView!
    
    var currentUserName = ""
    var currentUserPoints = 0
    
    var userToCompareName = ""
    var userToComparePoints = 0
    
    var startValue: Double = 0
    var animationStartDate = Date()
    let animationDuration: Double = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        topInnerContainerView.backgroundColor = UIColor (white: 0.4, alpha: 0.5)
        bottomInnerContainerView.backgroundColor = UIColor(white: 0.4, alpha: 0.5)
        
        topInnerContainerView.layer.cornerRadius = 8.0
        bottomInnerContainerView.layer.cornerRadius = 8.0
        
        userToCompareNameLabel.text = userToCompareName
        currentUserNameLabel.text = currentUserName
        
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc func handleUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            currentUserPointsLabel.text = "\(currentUserPoints)"
            userToComparePointsLabel.text = "\(userToComparePoints)"
        }
        else {
            let percentage = elapsedTime / animationDuration
            let value = percentage * (Double(currentUserPoints) - startValue)
            currentUserPointsLabel.text = "\(Int(value))"
            
            let compareValue = percentage * (Double(userToComparePoints) - startValue)
            userToComparePointsLabel.text = "\(Int(compareValue))"
        }
    }
    
    @IBAction func backButtonpressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
