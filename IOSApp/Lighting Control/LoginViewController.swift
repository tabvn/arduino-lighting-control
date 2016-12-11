//
//  LoginViewController.swift
//  Lighting Control
//
//  Created by Toan on 12/11/16.
//  Copyright © 2016 tabvn. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    let titleLabel: UILabel = {
    
    
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Login To the App"
        label.textAlignment = .center
        
        return label
    }()
    
    
    let emailField: UITextField = {
    
        let tf = UITextField()
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email address"
        tf.keyboardType = .emailAddress
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        
        
        
        return tf
    }()
    
    
    let passwordField: UITextField = {
        
        let tf = UITextField()
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Your password"
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        
        
        
        return tf
    }()
    
    lazy var submitButton: UIButton = {
    
        let bt = UIButton()
        
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Login", for: .normal)
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    
        bt.isEnabled = true
        bt.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    
        
    
        
        return bt
    
    }()

    
    let lineSep: UIView = {
    
        let view = UIView()
        
        view.layer.backgroundColor = UIColor.gray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.5
        
        return view
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupViews()
    }
    
   func setupViews(){
    
    
        view.backgroundColor = UIColor.white
    
    
    
    
        // title label
    
        view.addSubview(titleLabel)
    
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    
        // email
    
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(submitButton)
    
    
        // email auto layout
    
        emailField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        emailField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    
    
        // line 
    
        view.addSubview(lineSep)
        lineSep.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 5).isActive = true
        lineSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineSep.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        lineSep.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    
    
        passwordField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        passwordField.topAnchor.constraint(equalTo: lineSep.bottomAnchor, constant: 20).isActive = true
        passwordField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    
        submitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20).isActive = true
        submitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }
    
    
    
    
    
    func handleLogin(){
        
        
    
        let email = emailField.text
        let password = passwordField.text
        
        if(email == "" || password == ""){
            
            let alertViewController = UIAlertController(title: "An error", message: "Email and password required", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated: true, completion: nil)
        }else{
            
            
            // do login here
            
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user: FIRUser?, err: Error?) in
                
                if let error = err{
                    
                    print(error)
                    
                    return
                }
                if let user = user{
                    print("User logged in with data: ", user.uid)
                    
                    // now redirect user to main table view
                    
                    let navController = UINavigationController(rootViewController: MainTableViewController())
                    
                    self.present(navController, animated: true, completion: {
                        
                        //
                    })
                    
                }
                
            })
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
