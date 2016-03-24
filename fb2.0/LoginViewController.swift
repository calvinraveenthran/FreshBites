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

class LoginViewController: UIViewController,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate  {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController();
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameField.delegate = self;
        self.passwordField.delegate = self;
        
        self.usernameField.autocorrectionType = UITextAutocorrectionType.No;
        self.passwordField.autocorrectionType = UITextAutocorrectionType.No;
        
    
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
            
        let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 4 characters & Password must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
        } else {
            
            self.actInd.startAnimating()
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: {(user,error) ->
                Void in
                
                self.actInd.stopAnimating()
                
                if ((user != nil)){
                    self.usernameField.text = ""
                    self.passwordField.text = ""
                    let alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:SWRevealViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("revealViewController") as! SWRevealViewController
                        
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
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

