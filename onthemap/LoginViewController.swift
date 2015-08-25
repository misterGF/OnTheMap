//
//  LoginViewController.swift
//  onthemap
//
//  Created by Gil Ferreira on 8/23/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //Define outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupLinkButton: UIButton!
    @IBOutlet weak var signinWithFbButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    
    var appDelegate: AppDelegate!
    var session : NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Get delegate and shared session
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        session = NSURLSession.sharedSession()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Set debug text to nothing
        self.debugLabel.text = ""
        
    }

    //Actions
    @IBAction func loginButtonTouch(sender: AnyObject) {
      
        var userCreds = [
            UdacityClient.ParameterKeys.Username : emailTextField.text,
            UdacityClient.ParameterKeys.Password : passwordTextField.text
        ]
        
        UdacityClient.sharedInstance().authenticateWithViewController(userCreds) { (success, errorString) in
            
            if success {
               self.completedLogin()
            }
            else {
               self.displayError(errorString)
            }
        }
        
    }
    
    @IBAction func signinFBButtonTouch(sender: AnyObject) {
 
        println("Signin FB - implement me")
    }
    
    @IBAction func signupButtonTouch(sender: AnyObject) {
        
        var url = NSURL(string : "https://www.udacity.com/account/auth#!/signin")
        UIApplication.sharedApplication().openURL(url!)
        
        
    }
    
    //Helper functions
    func completedLogin(){
        
        println("Completed Login - implement me. Should segue")
        
    }
    
    func displayError(errorString: String?){
    
        dispatch_async(dispatch_get_main_queue(), {
          
            if let errorString = errorString {
                self.debugLabel.text = errorString
            }
            
        })
    
    }


}

