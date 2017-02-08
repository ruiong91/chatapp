//
//  SignUpViewController.swift
//  NextChat
//
//  Created by Rui Ong on 02/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference!
    var users : [User] = []
    
    @IBOutlet weak var signUpBtn: UIButton!{
        didSet{
            signUpBtn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var displayNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        
//        dbRef.child("user").observe(.value, with: { (snapshot) in
//            if let snapValues = snapshot.value as? [Any] {
//                var userIndex = 0
//                var tempUsers : [User] = []
//                
//                for value in snapValues {
//                    if let userDictionary = value as? [String : Any] {
//                        let newUser = User(withDictionary: userDictionary, index : userIndex)
//                        userIndex += 1
//                        tempUsers.append(newUser)
//                    }
//                }
//                self.users = tempUsers
//            }
//        })
    }
    
        
        
        func signUp(){
            FIRAuth.auth()?.createUser(withEmail: usernameTF.text!, password: passwordTF.text!, completion: { (user, error) in
                if error != nil {
                    print(error as! NSError)
                    return
                }
                

                let userDictionary : [String: Any] = ["displayName" : self.displayNameTF.text ?? "", "email" : self.usernameTF.text ?? "", "password" : self.passwordTF.text ?? ""]
                
                guard let validUserID = user?.uid else { return }
                
                self.dbRef.child("users").updateChildValues([validUserID:userDictionary])
                
            })
        }
}

