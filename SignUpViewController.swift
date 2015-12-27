//
//  SignUpViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2015-11-23.
//  Copyright © 2015 Calvin Raveenthran. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signUP(sender: AnyObject) {
        let uName = self.username.text
        let pWord = self.password.text
        let confirmPWord = self.confirmPassword.text
        let eMail   = self.email.text
        
        if (uName?.utf16.count < 4 || pWord?.utf16.count < 5){
            let alert = UIAlertView(title: "Invalid", message:
                "Username must be greater than 4 characters & Password must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else if(eMail?.utf16.count < 8) {
            let alert = UIAlertView(title: "Invalid", message:
                "Email should be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else if(pWord != confirmPWord){
            let alert = UIAlertView(title: "Invalid", message:
                "Password entries do not match", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else{
            self.actInd.startAnimating()
            
            let newUser = PFUser()
            newUser.password = pWord
            newUser.email = eMail
            newUser.username = uName
            
            newUser.signUpInBackgroundWithBlock({ (succeed,error) -> Void in
                self.actInd.stopAnimating()
                if(error != nil){
                    var alert = UIAlertView(title: "Error", message:
                        "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }else{
                    var alert = UIAlertView(title: "Success", message:
                        "User was created", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            })
        }

    }
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
