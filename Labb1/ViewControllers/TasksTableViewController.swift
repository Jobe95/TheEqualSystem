//
//  TasksTableViewController.swift
//  Labb1
//
//  Created by Jonatan Bengtsson on 2019-03-12.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class TasksTableViewController: UITableViewController {
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    var taskArray = [Tasks]()
    
    var tasksFromFirebase = [String]()
    var valuesFromFirebase = [Int]()
    var ownerFromFirebase = [String]()
    var taskIdFromFirebase = [String]()
    var imageOfUserTask = [String]()
    
    
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet var tasksTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupBackgroundImage()
        setupNavigationBar()
        retrieveTasksFromDB()
    }
    func setupBackgroundImage() {
        let backgroundImage = UIImage(named: "michal-grosicki-235026")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: backgroundImage)
        tasksTableView.backgroundView = imageView
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Tasks"
        
        let profileButton = UIButton(type: .system)
        let addTaskButton = UIButton(type: .contactAdd)
        let logOutButton = UIButton(type: .system)
        
        profileButton.setImage(UIImage(named: "friends_icon"), for: .normal)
        profileButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        addTaskButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        logOutButton.setTitle("Logout", for: .normal)
        logOutButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        addTaskButton.addTarget(self, action: #selector(addNewTaskButtonPressed), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logOutButton)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: addTaskButton), UIBarButtonItem(customView: profileButton)]
    }
    
    // MARK: - NavBar buttons
    @objc func profileButtonPressed(sender: UIButton) {
        performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    @objc func addNewTaskButtonPressed(sender: UIButton) {
        performSegue(withIdentifier: "goToAddTask", sender: self)
    }
    
    //Loggar ut användaren och poppar viewcontrollers till rootView
    @objc func logOutButtonPressed(sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //Hämtar alla tasks som är false, lägger till info i task array bestående av task
    func retrieveTasksFromDB() {
        db.collection("tasks").whereField("taskDone", isEqualTo: false)
            .getDocuments {
                (snapshot, error) in
                if error != nil{
                    print("Something went wrong\(error!)")
                }else {
                    for document in snapshot!.documents {
                        if let snapshotValue = document.data() as? [String : Any] {
                            
                            let owner = snapshotValue ["owner"] as! String
                            let taskDone = snapshotValue ["taskDone"] as! Bool
                            let taskImageUrl = snapshotValue ["taskImage"] as! String
                            let taskName = snapshotValue ["taskName"] as! String
                            let userID = snapshotValue ["userID"] as! String
                            let valueOfTask = snapshotValue ["valueOfTask"] as! Int
                            
                            let task = Tasks()
                            task.owner = owner
                            task.taskDone = taskDone
                            task.taskImageUrl = taskImageUrl
                            task.taskName = taskName
                            task.userId = userID
                            task.valueOfTask = valueOfTask
                            task.taskIdFromDB = document.documentID
                            
                            self.taskArray.append(task)
                    }
                }
                    self.tasksTableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return taskArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! CustomTaskTableViewCell
        
        // Configure the cell...
        cell.layer.cornerRadius = 8.0
        cell.backgroundColor = UIColor .clear
        cell.cellView.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        
        cell.userEmailLabel.text = "Created by: \(taskArray[indexPath.row].owner)"
        cell.taskLabel.text = taskArray[indexPath.row].taskName
        cell.valueLabel.text = "Value: \(taskArray[indexPath.row].valueOfTask)"
        
        let imgUrl = taskArray[indexPath.row].taskImageUrl
        let url = URL(string: imgUrl)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.avatarImageView.image = UIImage(data: data!)

                cell.avatarImageView.roundedCornersImage()

            }
        }
        return cell
    }
    
    //Tar hand om klick på en cell.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCompleteTask", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCompleteTask" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! CompletedTaskViewController
                destinationVC.task = taskArray[indexPath.row]
            }
        }
    }
}
