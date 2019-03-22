//
//  ProfileViewController.swift
//  Labb1
//
//  Created by Jonatan Bengtsson on 2019-03-15.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPointsLabel: UILabel!
    
    @IBOutlet weak var profileView: UIView!
    
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var userID = Auth.auth().currentUser?.uid
    var db = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    
    var users = [User]()
    var currentUserPoints = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        profileTableView.backgroundColor = .clear
        navigationItem.title = "Profile"
        
        //TODO: Mecka för att lösa cirkelbilder!
        avatarImageView.roundedImage()
        profileView.layer.cornerRadius = 8.0
        profileView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        
        getUsersInformation()
        // Do any additional setup after loading the view.
    }
    
    func getUsersInformation() {
        let userRef = db.collection("users")
        userRef.getDocuments {
            (snapshot, error) in
            if let error = error {
                print("Something went wrong getting all users\(error)")
            }
            else {
                for document in snapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    
                    if let dictionary = document.data() as? [String : Any] {
                        
                        let id = dictionary["userID"] as! String
                        if self.userID == id {
                            //Om id matchar currentUser så lägger vi ej till i listan
                            //Vi uppdaterar värdena som behövs för att visa user points och bild
                            let points = dictionary["points"] as! Int
                            self.userPointsLabel.text = "\(points)"
                            self.currentUserPoints = points
                            self.userNameLabel.text = self.currentUser?.displayName
                            self.userEmailLabel.text = self.currentUser?.email
                            if let profileImageUrl = self.currentUser?.photoURL {
                                
                                DispatchQueue.global().async {
                                    let data = try? Data(contentsOf: profileImageUrl)
                                    DispatchQueue.main.async {
                                        self.avatarImageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                        else {
                            let user = User()
                            let userName = dictionary["username"] as! String
                            let userEmail = dictionary["email"] as! String
                            let userPoints = dictionary["points"] as! Int
                            let userImageUrl = dictionary["profileImageURL"] as! String
                            
                            user.username = userName
                            user.email = userEmail
                            user.points = userPoints
                            user.profileImageUrl = userImageUrl
                            user.userIdFromCollection = document.documentID
                            
                            self.users.append(user)
                        }
                    }
                }
                self.profileTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! CustomProfileTableViewCell
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cell.layer.cornerRadius = 8.0
        
        cell.userNameLabel.text = users[indexPath.row].username
        cell.userEmaillabel.text = users[indexPath.row].email
        
        //Laddar ner bilden asynkroniskt"i bakgrunden utan att låsa UI"
        let imgUrl = users[indexPath.row].profileImageUrl
            let url = URL(string: imgUrl)
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.userAvatarImage.image = UIImage(data: data!)
                }
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCompare", sender: self)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCompare" {
            if let indexPath = profileTableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! CompareProfilesViewController
                
                destinationVC.userToCompareName = users[indexPath.row].username
                destinationVC.userToComparePoints = users[indexPath.row].points
                
                destinationVC.currentUserName = (currentUser?.displayName)!
                destinationVC.currentUserPoints = currentUserPoints
            }
        }
    }
}
