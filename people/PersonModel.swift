//
//  Person.swift
//  people
//
//  Created by John Grayson on 21/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import Foundation
import CoreData

class PersonModel : NSObject {
    
    private var person : NSManagedObject!
    
    var name: String {
        get {
            return person.valueForKey("name") as! String
        }
    }
    
    init(person: NSManagedObject) {
        self.person = person
    }
    
}