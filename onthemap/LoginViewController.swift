//
//  LoginViewController.swift
//  onthemap
//
//  Created by Gil Ferreira on 8/23/15.
//  Copyright (c) 2015 Gil Ferreira. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    //Define outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupLinkButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var fbLoginView: UIView!
    
    var appDelegate: AppDelegate!
    var session : NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Get delegate and shared session
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        session = NSURLSession.sharedSession()
                
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = CGPoint(x: 200, y: 50)
        loginButton.delegate = self
        fbLoginView.addSubview(loginButton)


    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Set debug text to nothing
        self.debugLabel.text = ""
        
    }

    //Actions
    @IBAction func loginButtonTouch(sender: AnyObject) {
      
        println("login button clicked")
        var userCreds = [
            UdacityClient.ParameterKeys.Username : emailTextField.text,
            UdacityClient.ParameterKeys.Password : passwordTextField.text
        ]
        
        UdacityClient.sharedInstance().authenticateWithViewController(userCreds, parameterKey: UdacityClient.ParameterKeys.Udacity) { (success, errorString) in
            
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
    func displayError(errorString: String?){
    
        dispatch_async(dispatch_get_main_queue(), {
          
            if let errorString = errorString {
                self.debugLabel.text = errorString
                self.alertError(errorString)
            }
            
        })
    
    }

    // Facebook Delegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            println("Login complete.")
            
            if var token = result.token.tokenString {
 
                var userFBAccessToken = [
                    UdacityClient.ParameterKeys.AccessToken : token
                ]
                
                UdacityClient.sharedInstance().authenticateWithViewController(userFBAccessToken, parameterKey: UdacityClient.ParameterKeys.Facebook) { (success, errorString) in
                    
                    if success {
                        self.completedLogin()
                    }
                    else {
                        self.displayError(errorString)
                    }
                }
            }
            

        }
        else
        {
            println(error.localizedDescription)
            self.displayError(error.localizedDescription)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        println("User logged out...")
    }
}

