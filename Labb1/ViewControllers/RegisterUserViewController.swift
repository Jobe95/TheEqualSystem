//
//  RegisterUserViewController.swift
//  Labb1
//
//  Created by Jonatan Bengtsson on 2019-03-13.
//  Copyright © 2019 Jonatan Bengtsson. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profileImageView.image = UIImage(named: "Money")
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageView)))
        profileImageView.isUserInteractionEnabled = true
        
        registerButton.backgroundColor = UIColor .flatNavyBlue()
        
        navigationItem.title = "Register"
        
    }
    
    @objc func handleProfileImageView() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Did cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        if let selected = selectedImage {
            profileImageView.image = selected
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        registerButton.isEnabled = false
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            
            if error != nil {
                print("Something went wrong when creating user \(error!)")
            }
            else {
                print("Authentication works")
                // Add a new document with a generated ID
                let uid : String = (Auth.auth().currentUser?.uid)!
                //Skapar en random string för att sedan sätta den som id för bilderna i DB.
                let imageName = NSUUID().uuidString
                let storageRef = self.storage.reference().child("profile_images").child("\(imageName).png")
                
                if let imageData = self.profileImageView.image!.pngData() {
                    
                    storageRef.putData(imageData, metadata: nil, completion: {
                        (metadata, error) in
                        if error != nil {
                            print("Something went wrong with uploading image \(error!)")
                        }
                        else {
                            storageRef.downloadURL(completion: {
                                (url, error) in
                                print("Här är url\(url!)")
                                
                                // Lägger till värdena till userobjektet i en dictionary
                                if let profileImageUrl = url?.absoluteString {
                                    let valuesForUser = ["username": self.firstNameTextField.text!,
                                                         "email": self.emailTextField.text!,
                                                         "userID": uid,
                                                         "points": 0,
                                                         "profileImageURL": profileImageUrl] as [String : AnyObject]
                                    
                                    self.registerUserToDatabase(values: valuesForUser, imageURL: profileImageUrl)
                                }
                            })
                            print(metadata!)
                        }
                        self.registerButton.isEnabled = true
                        SVProgressHUD.dismiss()
                    })
                }
            }
        }
    }
    // Tar in en dictionary av alla variabler som user objektet ska ha
    func registerUserToDatabase(values: [String : AnyObject], imageURL: String) {
        
        var ref: DocumentReference? = nil
        
        ref = self.db.collection("users").addDocument(data: values, completion: {
            (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.updateUser(updateImageUrl: imageURL)
                self.performSegue(withIdentifier: "goToTasks", sender: self)
            }
        })
    }
    
    //Uppdaterar user displayname och user photoURL så jag kan använda dessa vriabler på currentUser Objektet.
    func updateUser (updateImageUrl: String) {
        let url = URL(string: updateImageUrl)
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = self.firstNameTextField.text!
        changeRequest?.photoURL = url
        
        changeRequest?.commitChanges {
            (error) in
            if error != nil {
                print("Wrong with updating username")
                print(error!)
            }
            else {
                print("Updating username was succesfull!")
            }
        }
    }
}
