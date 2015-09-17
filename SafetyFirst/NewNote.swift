//
//  NewNote.swift
//  SafetyFirst
//
//  Created by Vincent Pacul on 14/7/15.
//  Copyright (c) 2015 Vincent Pacul. All rights reserved.
//

import UIKit
import CoreData


class NewNote: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateField: UILabel!
    //@IBOutlet weak var notesContentField: UITextView!
    @IBOutlet weak var addPurposeBtn: UIButton!
   
    var purposeTextF: UITextField!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Create Date
        dateCreation()
        
        //Create a save button inside navigationbar
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveNote:"))
        //put the new created button in the right side of our navigation bar
        self.navigationItem.rightBarButtonItem = saveButton
        
        //Dismiss key board when tap any where
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tapToDismissKeyboard)
        
        //Make an observer of the app state
        ObserverClass.sharedInstance.observApplicationState(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Helper Methods
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer){
        self.dismissKeyboard()
    }
    
    func dismissKeyboard(){
        self.titleField.resignFirstResponder()
      //  self.notesContentField.resignFirstResponder()
        
    }
    
    func dateCreation(){
        
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        dateField.text = String(format: "%@",timestamp)
        
    }
    
    //MARK: Notification Methods
    func backgroundObserverMethod(notification : NSNotification) {
        //You may call your action method here, when the application did enter background.
        
        //delay it for a minute
        ObserverClass.sharedInstance.delay(30){
            ObserverClass.sharedInstance.dismissView()
        }
    }

    //MARK: TextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    func configurationTextField(textField: UITextField!)
    {
        purposeTextF = textField
    }
    
    
    /*Saving the new created note in core data*/
    func saveNote(sender: UIBarButtonItem) {
        
        //        if(!self.titleField.text.isEmpty){
        //           CoreDataManager.sharedInstance.saveNewNote(self.titleField.text, noteContent: self.notesContentField.text, noteLastUpdate: self.dateField.text!, noteCreated: self.dateField.text!)
        //           self.dismissKeyboard()
        //        }
        
    }
}
