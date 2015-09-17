//
//  ViewController.swift
//  SafetyFirst
//
//  Created by Vincent Pacul on 14/7/15.
//  Copyright (c) 2015 Vincent Pacul. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var lblAuthResult: UILabel!
    @IBOutlet weak var passcodeView: UIView!
    @IBOutlet weak var passcodeTextfeild: UITextField!
    @IBOutlet weak var createPasscode: UIButton!
    
    var password:NSString!
    var isPassSet:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Dismiss key board when tap any where
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tapToDismissKeyboard)
        
        //Set NoteContentTxtView delegate
        self.passcodeTextfeild.delegate = self
        
        if isPassCodeSet(){
            self.createPasscode.setTitle("Passcode", forState: .Normal)
        }else{
            self.createPasscode.setTitle("Create Passcode", forState: .Normal)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.passcodeView.alpha = 0.0
        self.passcodeTextfeild.text = ""
        self.lblAuthResult.text = ""
    }
    
    //Mark: Login Using  Touch ID
    @IBAction func touchIDProcess(sender: AnyObject) {
        
        let authContext:LAContext = LAContext()
        var error:NSError?
        self.lblAuthResult.text = ""
        
        if(authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics)){
        
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Touch ID", reply: {(wasSuccessfull:Bool,error:NSError?) in
                
                if(wasSuccessfull){
                    
                    self.gotoContentData()
                }
                else{
                    self.writeOutAuthResult(error)
                }
                
            })
        
        }else{
           self.writeOutAuthResult(error)
        }
        
        
    }
    
    @IBAction func createAPasscode(sender: AnyObject){
        
        self.animateLogin()
    }
    
    //MARK: Helper Methods
    func writeOutAuthResult(authError:NSError?){
        
        dispatch_async(dispatch_get_main_queue(), {()in
            
            if let possibleError = authError
            {
                self.lblAuthResult.textColor = UIColor.redColor()
                switch possibleError.code{
                case LAError.SystemCancel.rawValue: self.lblAuthResult.text = "Authentication was cancelled by the system"
                case LAError.UserFallback.rawValue:  NSOperationQueue.mainQueue().addOperationWithBlock( { () -> Void in self.animateLogin() } )
                case LAError.TouchIDNotEnrolled.rawValue: self.lblAuthResult.text = "TouchID is not enrolled"
                case LAError.PasscodeNotSet.rawValue: self.lblAuthResult.text = "Passcode has not been set"
                default: self.lblAuthResult.text = "Authentication failed"
                }
                
            }
        })
    }
    
    func gotoContentData(){
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), { ()->() in
            let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("ContentList")
            self.showViewController(vc as! UIViewController, sender: vc)
        })
        
    }
    
    func animateLogin(){
        
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), { ()->() in
            UIView.animateWithDuration(1.0,
                delay: 1.0,
                options: [.CurveEaseInOut, .AllowUserInteraction],
                animations: {
                    self.passcodeView.alpha = 1
                    self.passcodeTextfeild.text = ""
                },
                completion: { finished in
            })
            
            
        })
    }
    
    func isPassCodeSet() ->Bool{
        CoreDataManager.sharedInstance.fetchDataFromCoreDataForUserLogin()
        password = CoreDataManager.sharedInstance.getOnePasscode()
        
        if password == ""{
            isPassSet = false
        }else{
            isPassSet = true
        }
        return isPassSet
    }
    
    func usingPasscode(){
        
        if isPassCodeSet(){
           
            if self.passcodeTextfeild.text != "" && self.passcodeTextfeild.text == password{
                 self.gotoContentData()
            }else{
                self.lblAuthResult.textColor = UIColor.redColor()
                self.lblAuthResult.text = "Wrong Passcode"
            }
        }else{
            CoreDataManager.sharedInstance.saveNewPass(self.passcodeTextfeild.text as NSString)
            self.createPasscode.setTitle("Passcode", forState: .Normal)
            self.passcodeView.alpha = 0.0
        }
        
        
    }

    func handleTap(gestureRecognizer: UITapGestureRecognizer){
        self.passcodeTextfeild.resignFirstResponder()
    }
    
    //MARK: TextField Delegates
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.passcodeTextfeild.resignFirstResponder()
        self.usingPasscode()
        return true
    }
    
   
    
    
    

   
}

