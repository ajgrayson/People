//
//  Person.swift
//  people
//
//  Created by John Grayson on 22/07/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass

    var timeSinceLastContact : String {
        get {
            let dateRaw : AnyObject? = self.valueForKey("lastContactedDate")
            if dateRaw == nil {
                return ""
            }
            let date = dateRaw as! NSDate
            return date.relativeTime
        }
    }

    
}