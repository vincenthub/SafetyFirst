//
//  ListNotesController.swift
//  SafetyFirst
//
//  Created by Vincent Pacul on 15/7/15.
//  Copyright (c) 2015 Vincent Pacul. All rights reserved.
//

import UIKit
import CoreData

class ListNotesController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var emptyList: UILabel!
    
    var listofProfile = [OneProfile]()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Create a logout button inside navigationbar
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("logoutPress:"))
       
        //put the new created button in the right side of our navigation bar
        self.navigationItem.leftBarButtonItem = logoutButton
       
        
        // Translucency of the navigation bar is disabled so that it matches with
        // the non-translucent background of the extension view.
        self.navigationController?.navigationBar.translucent = false
        // The navigation bar's shadowImage is set to a transparent image.  In
        // conjunction with providing a custom background image, this removes
        // the grey hairline at the bottom of the navigation bar.  The
        // ExtendedNavBarView will draw its own hairline.
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "TransparentPixel"), forBarMetrics:.Default)

        //get data from datamanager (Core Data)
        self.getDataFromManager()
       
        //check if list is empty and display "Create Profile" otherwise show table
        self.checkListIsEmpty()
        
        //Make an observer of the app state
        ObserverClass.sharedInstance.observApplicationState(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //get data from datamanager (Core Data)
        self.getDataFromManager()
        //check if list is empty and display "Create Profile" otherwise show table
        self.checkListIsEmpty()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: My Helper Methods/Functions
    
    func getDataFromManager(){
        CoreDataManager.sharedInstance.fetchDataFromCoreDataOneProfile()
        listofProfile = CoreDataManager.sharedInstance.getListOfProfiles()
        self.notesTableView.reloadData()
    }
    
    func checkListIsEmpty(){
        if(listofProfile.count == 0){
            self.emptyList.hidden = false
            self.notesTableView.hidden = true
        }else{
            self.emptyList.hidden = true
            self.notesTableView.hidden = false
        }
    }
    //dissmiss this view
    func dismissView(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    //MARK: Notification Methods
    func backgroundObserverMethod(notification : NSNotification) {
        //You may call your action method here, when the application did enter background.
        
        //delay it for a minute
        ObserverClass.sharedInstance.delay(0.5){
            self.dismissView()
        }
    }

    
    //Mark: TableView Delegates
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = notesTableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath) as! CommonTableViewCell
        
        let data = listofProfile[indexPath.row]
        
        cell.profileTitleCell.text = data.profileTitle
        cell.profileDateCreatedField.text = data.profLastUpdate
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        CoreDataManager.sharedInstance.setSpecificProfile(listofProfile[indexPath.row])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofProfile.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            CoreDataManager.sharedInstance.deleteProfileInTheList(indexPath.row)
            listofProfile.removeAtIndex(indexPath.row)
            self.notesTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if listofProfile.count == 0{
                self.checkListIsEmpty()
            }
        }
    }
    
    /*Saving the new created note in core data*/
    func logoutPress(sender: UIBarButtonItem) {
            self.dismissView()
    }
    
}
