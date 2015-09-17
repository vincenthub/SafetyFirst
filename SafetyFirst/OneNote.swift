//
//  OneNote.swift
//  
//
//  Created by Vincent Pacul on 29/7/15.
//
//

import Foundation
import CoreData

class OneNote: NSManagedObject {

    @NSManaged var noteContent: String
    @NSManaged var noteTitle: String
    @NSManaged var bugetSheetIn: OneBudgetSheet
    @NSManaged var purposeIn: OnePurpose
    @NSManaged var profileIn: OneProfile

}
