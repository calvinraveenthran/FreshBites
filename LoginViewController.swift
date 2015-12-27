//
//  ViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-11-16.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LoginViewController: UIViewController,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIAlertViewDelegate  {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController();
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() ==  nil){
            self.signUpViewController.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(sender: AnyObject) {
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        if (username?.utf16.count < 4 || password?.utf16.count < 5){
            
        let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 4 characters & Password must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK", otherButtonTitles:"")
            
            alert.show()
        } else {
            
            self.actInd.startAnimating()
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: {(user,error) ->
                Void in
                
                self.actInd.stopAnimating()
                
                if ((user != nil)){
                    let alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }else{
                    let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            })
            
        }
    }
    @IBAction func SignUp(sender: AnyObject) {
        self.performSegueWithIdentifier("signUpSegue", sender: nil)
    }

}

