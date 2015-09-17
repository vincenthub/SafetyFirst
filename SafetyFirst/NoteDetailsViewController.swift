//
//  NoteDetailsViewController.swift
//  SafetyFirst
//
//  Created by Vincent Pacul on 16/7/15.
//  Copyright (c) 2015 Vincent Pacul. All rights reserved.
//

import UIKit

class NoteDetailsViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailDateCreated: UILabel!
    @IBOutlet weak var detailEditNote: UITextView!
    @IBOutlet weak var detailPurpTable: UITableView!
    @IBOutlet weak var addPurpoLbl: UILabel!
    
    var detailProfile: OneProfile!
    var detailPurposes = [OnePurpose]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpAllDetails()
        
        //Dismiss key board when tap any where
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tapToDismissKeyboard)
        
        //check if list is empty and display "Add Purpose" otherwise show table
        self.checkListIsEmpty()
        
        //Make an observer of the app state
        ObserverClass.sharedInstance.observApplicationState(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpAllDetails(){
        
        detailProfile = CoreDataManager.sharedInstance.getOneProfileToDisplay()
        detailPurposes = CoreDataManager.sharedInstance.getAllPurposesInOneProfile()
        
        self.detailTitle.text = detailProfile.profileTitle
        self.detailDateCreated.text = detailProfile.profCreatedOn
        self.detailEditNote.text = detailProfile.note.noteContent
        
        
        self.detailPurpTable.reloadData()
    }
    
    func dateCreation() -> NSString{
        return NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer){
        self.detailEditNote.resignFirstResponder()
    }

    func dismissKeyboard(){
        self.detailEditNote.resignFirstResponder()
    }
    
    func checkListIsEmpty(){
        if(detailPurposes.count == 0){
            self.addPurpoLbl.hidden = false
            self.detailPurpTable.hidden = true
        }else{
            self.addPurpoLbl.hidden = true
            self.detailPurpTable.hidden = false
        }
    }
    
    //Mark: TableView Delegates
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = detailPurpTable.dequeueReusableCellWithIdentifier("detailPurpCell", forIndexPath: indexPath) as! CommonTableViewCell
        
        let everyCell = detailPurposes[indexPath.row]
        
        cell.detailPurposeTitleCell.text = everyCell.purposeTitle
        cell.detailPurposeDateCreatedField.text = everyCell.purposeLastUpdate

        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailPurposes.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            CoreDataManager.sharedInstance.deletePurposeInTheList(indexPath.row)
            detailPurposes.removeAtIndex(indexPath.row)
            self.detailPurpTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if detailPurposes.count == 0{
                self.checkListIsEmpty()
            }
        }
    }

    
    
    //MARK: TextViewDelegate Functions
    
    func textViewDidChange(textView: UITextView) {
        //Handle the text changes here
        
        //Create a save button inside navigationbar
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveNote:"))
        //put the new created button in the right side of our navigation bar
        self.navigationItem.rightBarButtonItem = doneButton

    }
    
    /*Saving the new created note in core data*/
    func saveNote(sender: UIBarButtonItem) {
        CoreDataManager.sharedInstance.updateProfileData(self.detailEditNote.text, dateUpdated: dateCreation(), profilePurposes: detailPurposes);
        dismissKeyboard()
    }
    
    //MARK: Notification Methods
    func backgroundObserverMethod(notification : NSNotification) {
        //You may call your action method here, when the application did enter background.
        
        //delay it for a minute
        ObserverClass.sharedInstance.delay(30){
            ObserverClass.sharedInstance.dismissView()
        }
    }

    
}
