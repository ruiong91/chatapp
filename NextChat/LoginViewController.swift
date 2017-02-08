//
//  LoginViewController.swift
//  NextChat
//
//  Created by Rui Ong on 02/02/2017.
//  Copyright © 2017 Rui Ong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    var currentUser : String?
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signUpPageBtn: UIButton!{
        didSet{
            signUpPageBtn.addTarget(self, action: #selector(loadSignUp), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    
    /// Login Function
    func login(){
        FIRAuth.auth()?.signIn(withEmail: usernameTF.text!, password: passwordTF.text!, completion: { (user, error) in
            
            //check if error
            if error != nil {
                print(error as! NSError)
                return
            }
            
            //get the user
            self.handleUser(user: user!)
            self.loadChannelPage()
        })
    }
    
    func handleUser(user: FIRUser){
        
        //print(user.displayName)
        
    }
    
    func loadSignUp(){
        let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let signUpPage = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        navigationController?.pushViewController(signUpPage!, animated: true)
    }
    
    func loadChannelPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let channelPage = storyboard.instantiateViewController(withIdentifier: "ChannelViewController") as? ChannelViewController
        
        navigationController?.pushViewController(channelPage!, animated: true)
    }
    
}
