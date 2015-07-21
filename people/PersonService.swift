//
//  UpdatePersonService.swift
//  people
//
//  Created by John Grayson on 21/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import Foundation
import CoreData

class PersonService : NSObject {
    
    var managedObjectContext : NSManagedObjectContext!
    
    init(context : NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func addPerson(name: String, addressBookRecordId: Int32?) -> NSManagedObject? {
        if name == "" {
            return nil
        }
        
        let entity =  NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext)
        
        var date = NSDate()
        
        var person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedObjectContext)
        
        person.setValue(date, forKey: "createdDate")
        person.setValue(name, forKey: "name")
        
        if addressBookRecordId != nil {
            person.setValue(NSNumber(int: addressBookRecordId!), forKey: "addressBookRecordId")
        }
        
        updatePerson(person)
        
        return person
    }
    
    func updatePerson(person : NSManagedObject) -> Bool {
        var date = NSDate()
        
        person.setValue(date, forKey: "updatedDate")
        
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            return false
        }
        return true
    }
    
    func getAllPeopleOrderedByName() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        var error: NSError?
        
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        
        if let results = fetchedResults {
            return results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
            return [NSManagedObject]()
        }
    }
    
    func doesPersonExist(addressBookRecordId: Int32) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        fetchRequest.predicate = NSPredicate(format: "addressBookRecordId = %@", argumentArray: [NSNumber(int: addressBookRecordId)])
        
        var error: NSError?
        
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        
        return fetchedResults?.count > 0
    }
    
}