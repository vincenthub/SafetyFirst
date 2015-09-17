//
//  OneBudgetSheet.swift
//  
//
//  Created by Vincent Pacul on 29/7/15.
//
//

import Foundation
import CoreData

class OneBudgetSheet: NSManagedObject {

    @NSManaged var budgetCreatedOn: String
    @NSManaged var budgetLastUpdate: String
    @NSManaged var budgetTitle: String
    @NSManaged var notes: OneNote
    @NSManaged var thisProfile: OneProfile

}
