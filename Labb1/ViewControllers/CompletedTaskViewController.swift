//
//  CompletedTaskViewController.swift
//  Labb1
//
//  Created by Jonatan Bengtsson on 2019-03-13.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit
import Firebase

class CompletedTaskViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var taskInformationLabel: UILabel!
    @IBOutlet weak var completeTaskButton: UIButton!
    
    @IBOutlet weak var topContainer: UIView!
    
    
    let db = Firestore.firestore()
    let currentUserId = Auth.auth().currentUser?.uid
    
    var userDocumentId : String = ""
    var points : Int = 10
    var updatedPoints : Int = 0
    
    var task = Tasks()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        completeTaskButton.backgroundColor = UIColor .flatGray()
        navigationItem.title = "Complete Task"
        topContainer.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        topContainer.layer.cornerRadius = 8.0
        
        getUserDetails()
        
        taskInformationLabel.text = "Name of task: \(task.taskName) \nValue for task: \(task.valueOfTask)"
    }
    @IBAction func completedTaskButtonPressed(_ sender: UIButton) {
        
        updateTaskAsDone()
        updateUserPoints()
        performSegue(withIdentifier: "goToTasks", sender: self)
    }
    
    func getUserDetails() {
        db.collection("users").whereField("userID", isEqualTo: currentUserId!).getDocuments {
            (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
            else {
                for document in snapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    self.userDocumentId = document.documentID
                    
                    if let dictionary = document.data() as? [String : Any] {
                        self.points = dictionary["points"] as! Int
                    }
                }
            }
        }
    }
    
    func updateUserPoints() {
        let userRef = db.collection("users").document(userDocumentId)
        
        updatedPoints = points + task.valueOfTask
        
        userRef.updateData([
            "points": updatedPoints
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Points successfully updated \(self.updatedPoints)")
            }
        }
    }
    
    func updateTaskAsDone() {
        
        let taskRef = db.collection("tasks").document(task.taskIdFromDB)
        
        // Set the "taskDone" field of to true
        taskRef.updateData([
            "taskDone": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Updated taskDone to true successfully")
            }
        }
    }
}
