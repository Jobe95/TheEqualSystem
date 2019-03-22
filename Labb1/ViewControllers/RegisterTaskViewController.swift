//
//  RegisterTaskViewController.swift
//  Labb1
//
//  Created by Jonatan Bengtsson on 2019-03-13.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit
import Firebase

class RegisterTaskViewController: UIViewController {

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet weak var registerTaskButton: UIButton!
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Register Task"
        registerTaskButton.backgroundColor = UIColor .flatNavyBlue()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTaskButtonPressed(_ sender: UIButton) {
        var ref: DocumentReference? = nil
        let valueOfTask : Int = Int(valueTextField.text!)!
        let uid : String = (currentUser?.uid)!
        let userName : String = (currentUser?.displayName)!
        let userImageStringUrl : String = (currentUser?.photoURL?.absoluteString)!
        
        ref = db.collection("tasks").addDocument(data: [
            "userID": uid,
            "owner": userName,
            "taskName": taskNameTextField.text!,
            "valueOfTask": valueOfTask,
            "taskDone": false,
            "taskImage": userImageStringUrl
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.performSegue(withIdentifier: "goToTasks", sender: self)
            }
        }
    }
}
