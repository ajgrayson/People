//
//  Reminder+CoreDataProperties.swift
//  people
//
//  Created by John Grayson on 1/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import Foundation
import CoreData

extension Reminder {
    
    @NSManaged var title: String?
    @NSManaged var date: NSDate?
    @NSManaged var note: String?
    @NSManaged var done: NSNumber?
    @NSManaged var createdDate: NSDate?
    @NSManaged var updatedDate: NSDate?
    @NSManaged var person: NSManagedObject?
    
}
