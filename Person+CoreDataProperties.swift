//
//  Person+CoreDataProperties.swift
//  people
//
//  Created by John Grayson on 22/07/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var addressBookRecordId: NSNumber?
    @NSManaged var createdDate: NSDate?
    @NSManaged var lastContactedDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var updatedDate: NSDate?
    @NSManaged var notes: NSSet?

}
