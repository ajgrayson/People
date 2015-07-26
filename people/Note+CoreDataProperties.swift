//
//  Note+CoreDataProperties.swift
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

extension Note {

    @NSManaged var content: String?
    @NSManaged var createdDate: NSDate?
    @NSManaged var updatedDate: NSDate?
    @NSManaged var person: NSManagedObject?
    @NSManaged var date: NSDate?
    @NSManaged var draft: NSNumber?
    
}
