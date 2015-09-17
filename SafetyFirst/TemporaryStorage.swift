//
//  TemporaryStorage.swift
//  SafetyFirst
//
//  Created by Vincent Pacul on 27/7/15.
//  Copyright (c) 2015 Vincent Pacul. All rights reserved.
//

import Foundation

class TemporaryStorage {
    
    private var tempProfileNote: NSString!
    private var tempProfileTitle: NSString!
    private var tempProfileCreated: NSString!
    private var tempProfileLastCreated: NSString!
    private var templistOfPurposes = [TemporaryStorageClass]()
    
    //It makes this class to be a singleton
    class var sharedInstance: TemporaryStorage {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var SelfInstance: TemporaryStorage? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.SelfInstance = TemporaryStorage()
        }
        return Static.SelfInstance!
    }
    
    
    
    //Profile
    
    func setTempProf(tempProfTitle:NSString,tempNote:NSString,tempDateCreated:NSString, tempLastCreated:NSString){
        self.tempProfileTitle = tempProfTitle
        self.tempProfileCreated = tempDateCreated
        self.tempProfileLastCreated = tempLastCreated
        self.tempProfileNote = tempNote
        
    }
    
    func getTempProfile() -> (NSString,NSString,NSString,NSString){
        return (self.tempProfileTitle,self.tempProfileCreated,self.tempProfileLastCreated,self.tempProfileNote)
    }
    
    //Purpose
    
    func addTempPurpose(tempPurpTitle:NSString, tempPurpDesc:NSString, tempDateCreated:NSString, tempLastCreated:NSString){
        
        let temp = TemporaryStorageClass()
        temp.tempTitlePurp = tempPurpTitle
        temp.tempDesc = tempPurpDesc
        temp.tempDateCreated = tempDateCreated
        temp.tempLastUpdate = tempLastCreated
        
        self.templistOfPurposes.append(temp)
        
    }
    
    func getListOfTempPurp() -> [TemporaryStorageClass]{
        return self.templistOfPurposes
    }
    
    /*Delete a data in Core Data*/
    func deleteTempPurpInTheList(indexToDelete:NSInteger){
        templistOfPurposes.removeAtIndex(indexToDelete)
    }
    
}

