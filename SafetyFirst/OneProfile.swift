//
//  OneProfile.swift
//  
//
//  Created by Vincent Pacul on 29/7/15.
//
//

import Foundation
import CoreData

class OneProfile: NSManagedObject {

    @NSManaged var profCreatedOn: String
    @NSManaged var profileTitle: String
    @NSManaged var profLastUpdate: String
    @NSManaged var bugetSheetIn: NSSet
    @NSManaged var purposes: NSSet
    @NSManaged var note: OneNote

}
