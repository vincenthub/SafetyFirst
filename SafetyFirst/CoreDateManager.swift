//
//  CoreDateManager.swift
//  SafetyFirst
//
//  Created by Vincent Pacul on 15/7/15.
//  Copyright (c) 2015 Vincent Pacul. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager{
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    private var listOfProfiles = [OneProfile]()
    private var oneProfile: OneProfile!
    private var listOfPurposes = [OnePurpose]()
    private var userPass = [UserLogin]()
    private var onePass: UserLogin!
    
    //It makes this class to be a singleton
    class var sharedInstance: CoreDataManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: CoreDataManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CoreDataManager()
        }
        return Static.instance!
    }
    
    //MARK: ---------------------------------------->> PROFILE COREDATA
    
    //return and array of OneProfile
    func getListOfProfiles() -> [OneProfile]{
        return listOfProfiles
    }
    
    //return a one profile
    func getOneProfileToDisplay()-> OneProfile{
        return self.oneProfile
    }

    //Set a specific profile to transport to other view/s
    func setSpecificProfile(profileToTransport: OneProfile){
        
         self.oneProfile = profileToTransport
        
    }
    
   
    //MARK: Fetching all profile in core data for OneProfile
    func fetchDataFromCoreDataOneProfile(){
        
        let fetchRequest = NSFetchRequest(entityName: "OneProfile")
        let sortDescriptor = NSSortDescriptor(key: "profLastUpdate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let error: NSError?
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest) as? [OneProfile] {
            listOfProfiles = fetchResults
        }else{
            print("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }
    
    func saveNewProfile() {
        
        let entityProfile = NSEntityDescription.entityForName("OneProfile", inManagedObjectContext: self.managedObjectContext!)
        let entityNote = NSEntityDescription.entityForName("OneNote", inManagedObjectContext: self.managedObjectContext!)
        let entityPurpose = NSEntityDescription.entityForName("OnePurpose", inManagedObjectContext: self.managedObjectContext!)
        
        let newProfile = NSManagedObject(entity: entityProfile!, insertIntoManagedObjectContext: self.managedObjectContext)
        let newNoteProf = NSManagedObject(entity: entityNote!, insertIntoManagedObjectContext: self.managedObjectContext!)
        
        
        let newDateProfile = TemporaryStorage.sharedInstance.getTempProfile()
        
            
        
            newProfile.setValue(newDateProfile.0, forKey: "profileTitle")
            newProfile.setValue(newDateProfile.1, forKey: "profCreatedOn")
            newProfile.setValue(newDateProfile.2, forKey: "profLastUpdate")
            //setValue for profile note
            NSLog("%@", newDateProfile.3)
            newNoteProf.setValue(newDateProfile.3, forKey: "noteContent")
            newNoteProf.setValue(newProfile, forKey: "profileIn")
            
            newProfile.setValue(newNoteProf, forKey: "note")
        
        
        
        let listPurp = TemporaryStorage.sharedInstance.getListOfTempPurp()
        
        
        if listPurp.count > 0 {
            
            var listOfPurp = [NSManagedObject]()
            
            for item in listPurp{
                
                let newPurpose = NSManagedObject(entity: entityPurpose!, insertIntoManagedObjectContext: self.managedObjectContext!)
                
                newPurpose.setValue(item.tempTitlePurp, forKey: "purposeTitle")
                newPurpose.setValue(item.tempLastUpdate, forKey: "purposeLastUpdate")
                newPurpose.setValue(item.tempDateCreated , forKey: "purposeCreatedOn")
                newPurpose.setValue(newProfile , forKey: "profileIn")
                
                let newNote = NSManagedObject(entity: entityNote!, insertIntoManagedObjectContext: self.managedObjectContext!)
                
                newNote.setValue(item.tempDesc , forKey: "noteContent")
                
                newPurpose.setValue(newNote, forKey: "purposeNote")
                
                listOfPurp.append(newPurpose)
                
            }
            
            let profilePurposes = newProfile.mutableSetValueForKey("purposes")
            
            profilePurposes.addObjectsFromArray(listOfPurp)
        }
        
        self.saveManageContent()
    
    }
   
    //Update OneNote data inside CoreData
    func updateProfileData(profileNote:NSString, dateUpdated:NSString, profilePurposes:[OnePurpose]) {
        
        //create a request
        let fetchRequest = NSFetchRequest()
        //create a new OneNote entity to be processed later
        let entityName = NSEntityDescription.entityForName("OneProfile", inManagedObjectContext: self.managedObjectContext!)
        //put the newly created entity inside our new created request
        fetchRequest.entity = entityName
        
        // Execute the fetch request
        let error : NSError?
        let fetchedObjects = self.managedObjectContext!.executeFetchRequest(fetchRequest) as? [OneProfile]
        
        if let profile = fetchedObjects {
            if error == nil {
                for item in profile {
                    if(item == oneProfile){
                        item.note.noteContent = profileNote as String
                        item.setValue(profilePurposes, forKey: "purposes")
                        break
                    }else{
                        continue
                    }
                }
            }
        }
        
        self.saveManageContent()
    }

    /*Delete a data in Core Data*/
    func deleteProfileInTheList(indexToDelete:NSInteger){
        managedObjectContext!.deleteObject(listOfProfiles[indexToDelete] as NSManagedObject)
        listOfProfiles.removeAtIndex(indexToDelete)
        var error : NSError?
        self.saveManageContent()
    }

    
    //---------------------------------------->> TO BE DELETED FOR EXAMPLE ONLY
    
    /*Saving the new created note in core data*/
    func saveNewNote(noteTitle:NSString, noteContent:NSString, noteLastUpdate:NSString, noteCreated:NSString) {
        
        let entity =  NSEntityDescription.entityForName("OneNote", inManagedObjectContext:managedObjectContext!)
        
        let newNote = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedObjectContext)
        
        newNote.setValue(noteTitle, forKey: "noteTitle")
        newNote.setValue(noteContent, forKey: "noteContent")
        newNote.setValue(noteLastUpdate, forKey: "noteLastUpdate")
        newNote.setValue(noteCreated, forKey: "noteCreated")
 
        self.saveManageContent()
        
    }
    
    
    
    
    //Update OneNote data inside CoreData
    func updateData(noteTitle:NSString, noteContent:NSString, noteLastUpdate:NSString, noteCreated:NSString) {
       
        //create a request
        let fetchRequest = NSFetchRequest()
        //create a new OneNote entity to be processed later
        let entityName = NSEntityDescription.entityForName("OneNote", inManagedObjectContext: self.managedObjectContext!)
        //put the newly created entity inside our new created request
        fetchRequest.entity = entityName
        
        // Execute the fetch request
        var error : NSError?
        var fetchedObjects: [AnyObject]?
        do {
            fetchedObjects = try self.managedObjectContext!.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            fetchedObjects = nil
        } // 4
        if let notes = fetchedObjects {
            if error == nil {
                for note in notes {
                    if((note as! OneNote).noteTitle == noteTitle){
                        (note as! OneNote).noteContent = noteContent as String
                        break
                    }else{
                        continue
                    }
                    
                }
            }
        }
        
        self.saveManageContent()
    }
    
    
    //MARK: ---------------------------------------->> PURPOSE COREDATA
  
    func getAllPurposesInOneProfile() -> [OnePurpose]{
        listOfPurposes = oneProfile.purposes.allObjects as! [OnePurpose]
        return listOfPurposes
    }
    
    /*Delete a data in Core Data*/
    func deletePurposeInTheList(indexToDelete:NSInteger){
        managedObjectContext!.deleteObject(listOfPurposes[indexToDelete] as NSManagedObject)
        listOfPurposes.removeAtIndex(indexToDelete)
        var error : NSError?
        self.saveManageContent()
    }

    
    //MARK: --------------------------------------->> Fetching password in core data
    func fetchDataFromCoreDataForUserLogin(){
        
        let fetchRequest = NSFetchRequest(entityName: "UserLogin")
        let error: NSError?
        if let userpass = managedObjectContext!.executeFetchRequest(fetchRequest) as? [UserLogin] {
            userPass = userpass
        }else{
            print("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }
    
    func getOnePasscode()-> NSString{
        
        if userPass.count != 0{
            for pass in userPass{
                onePass = pass
            }
            return onePass.userPass
        }else{
            return ""
        }
        
    }

    /*Saving a new created password in core data*/
    func saveNewPass(userPasscode:NSString) {
        
        let entity =  NSEntityDescription.entityForName("UserLogin", inManagedObjectContext:managedObjectContext!)
        
        let newPasscode = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedObjectContext)
        
        newPasscode.setValue(userPasscode, forKey: "userPass")
       
        
        self.saveManageContent()
        
    }

    
    //MARK: --------------------------------------->> HELPER METHOD
    func saveManageContent(){
        var error: NSError?
        do {
            try managedObjectContext!.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    
}