//
//  OnePurpose.swift
//  
//
//  Created by Vincent Pacul on 29/7/15.
//
//

import Foundation
import CoreData

class OnePurpose: NSManagedObject {

    @NSManaged var purposeAmount: String
    @NSManaged var purposeCreatedOn: String
    @NSManaged var purposeLastUpdate: String
    @NSManaged var purposeTitle: String
    @NSManaged var profileIn: OneProfile
    @NSManaged var purposeNote: OneNote

}
