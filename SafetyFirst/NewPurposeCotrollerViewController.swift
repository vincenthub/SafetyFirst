//
//  NewPurposeCotrollerViewController.swift
//  SafetyFirst
//
//  Created by Vincent Pacul on 24/7/15.
//  Copyright (c) 2015 Vincent Pacul. All rights reserved.
//

import UIKit

class NewPurposeCotrollerViewController: UIViewController {

    @IBOutlet weak var purDateCreated: UILabel!
    @IBOutlet weak var purTitleLbl: UITextField!
    @IBOutlet weak var purDesc: UITextView!
    @IBOutlet weak var noteView: UIView!
    var date:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.v
        
        //Create a new date for creating new purpose
        self.dateCreation()
        //Create a save button inside navigationbar
        let addButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addPurpose:"))
        //put the new created button in the right side of our navigation bar
        self.navigationItem.rightBarButtonItem = addButton
        
        //Create a cancel button inside navigationbar
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelViewController:"))
        //put the new created button in the right side of our navigation bar
        self.navigationItem.leftBarButtonItem = cancelButton

        //Dismiss key board when tap any where
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tapToDismissKeyboard)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateCreation(){
        
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        date = timestamp
        purDateCreated.text = String(format: "%@",date)
        
    }
    
    func addPurpose(sender: UIBarButtonItem){
        self.dismissKeyboard()
        TemporaryStorage.sharedInstance.addTempPurpose(self.purTitleLbl.text, tempPurpDesc: self.purDesc.text, tempDateCreated: date, tempLastCreated: date)
    }
    
    
    func cancelViewController(sender: UIBarButtonItem){
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer){
        self.dismissKeyboard()
    }
    
    func dismissKeyboard(){
        self.purDesc.resignFirstResponder()
        self.purTitleLbl.resignFirstResponder()
        
    }

}
