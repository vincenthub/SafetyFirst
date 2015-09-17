//
//  NewProfileController.swift
//  SafetyFirst
//
//  Created by Vincent Pacul on 24/7/15.
//  Copyright (c) 2015 Vincent Pacul. All rights reserved.
//

import UIKit

class NewProfileController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var purposeTable: UITableView!
    @IBOutlet weak var addPurposeBtn: UIButton!
    @IBOutlet weak var createLblShow: UILabel!
    @IBOutlet weak var profileNotes: UITextView!
    
    
    var listOfPurp:[TemporaryStorageClass] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //create date when one profile is created
        self.dateCreation()
        //Create a save button inside navigationbar
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveNote:"))
        //put the new created button in the right side of our navigation bar
        self.navigationItem.rightBarButtonItem = saveButton
        
        //Create a save button inside navigationbar
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelViewController:"))
        //put the new created button in the right side of our navigation bar
        self.navigationItem.leftBarButtonItem = cancelButton
        
        listOfPurp = [TemporaryStorageClass]()
        
        //Dismiss key board when tap any where
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tapToDismissKeyboard)
        
        //Make an observer of the app state
        ObserverClass.sharedInstance.observApplicationState(self)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
        listOfPurp = TemporaryStorage.sharedInstance.getListOfTempPurp()
        
        self.purposeTable.reloadData()
        self.checkListIsEmpty()
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
        self.profileNotes.resignFirstResponder()
    }
    
    func dateCreation(){
        
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        dateCreated.text = String(format: "%@",timestamp)
        
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
    
    @IBAction func addPurposePress(sender: AnyObject) {
        
        if self.titleField.text.isEmpty{
            
            self.doWarning()
        
        }else{
            
            TemporaryStorage.sharedInstance.setTempProf(self.titleField.text,tempNote: self.profileNotes.text, tempDateCreated: self.dateCreated.text!,tempLastCreated: self.dateCreated.text!)
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("NewPurposeView") 
            self.presentViewController(vc, animated: true, completion: nil)
        }
    
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = purposeTable.dequeueReusableCellWithIdentifier("purpCell", forIndexPath: indexPath) as! CommonTableViewCell
        
        let data = listOfPurp[indexPath.row]
        
        cell.purposeTitleCell.text = data.tempTitlePurp as String
        cell.purposeDateCreatedField.text = data.tempDateCreated as String
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfPurp.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            TemporaryStorage.sharedInstance.deleteTempPurpInTheList(indexPath.row)
            listOfPurp.removeAtIndex(indexPath.row)
            self.purposeTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if listOfPurp.count == 0{
                self.checkListIsEmpty()
            }
        }
    }

    
    /*Saving the new created note in core data*/
    func saveNote(sender: UIBarButtonItem) {
        
        if(!self.titleField.text.isEmpty){
        
            TemporaryStorage.sharedInstance.setTempProf(self.titleField.text,tempNote: self.profileNotes.text, tempDateCreated: self.dateCreated.text!,tempLastCreated: self.dateCreated.text!)
            
           CoreDataManager.sharedInstance.saveNewProfile()
        }else{
            self.doWarning()
        }
        
    }
    
    func doWarning(){
        let alert = UIAlertController(title: "Warning!", message: "Please input a title of your profile!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    
    func cancelViewController(sender: UIBarButtonItem){
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkListIsEmpty(){
        if(listOfPurp.count == 0){
            self.createLblShow.hidden = false
            self.purposeTable.hidden = true
        }else{
            self.createLblShow.hidden = true
            self.purposeTable.hidden = false
        }
    }

}
