//
//  PersonLastContactedService.swift
//  people
//
//  Created by John Grayson on 26/07/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import Foundation
import CoreData

class PersonLastContactedService : NSObject {
    
    var context : NSManagedObjectContext!
    
    init(context : NSManagedObjectContext) {
        self.context = context
    }
    
    func updateLastContacted(person : Person) {
        
        let fetchRequest = NSFetchRequest(entityName:"Note")
        
        fetchRequest.predicate = NSPredicate(format: "person = %@", argumentArray: [person])
        
        let sortDate = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDate]
        
        do {
            let fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Note]
            let latestNote = fetchedResults.first
            
            person.lastContactedDate = latestNote?.date
            
            try context.save()
        } catch {
            print("Failed to update last contacted date on person")
        }
        
    }
    
}