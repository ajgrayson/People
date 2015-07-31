//
//  ReminderService.swift
//  people
//
//  Created by John Grayson on 1/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import Foundation
import CoreData

class ReminderService : NSObject {
    
    var context : NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getAllRemindersFor(person: Person, orderedByDate: Bool) -> [Reminder] {
        let fetchRequest = NSFetchRequest(entityName:"Reminder")
        
        fetchRequest.predicate = NSPredicate(format: "person = %@", argumentArray: [person])
        
        if orderedByDate {
            let sortDate = NSSortDescriptor(key: "date", ascending: false)
            fetchRequest.sortDescriptors = [sortDate]
        }
        
        do {
            let fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Reminder]
            
            return fetchedResults
        } catch {
            return [Reminder]()
        }
    }
    
}