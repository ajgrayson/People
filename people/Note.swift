//
//  Note.swift
//  people
//
//  Created by John Grayson on 22/07/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import Foundation
import CoreData

class Note: NSManagedObject {

    var isDraft: Bool {
        get {
            return Bool(draft != nil && draft != 0)
        }
        set {
            draft = NSNumber(bool: newValue)
        }
    }

}
