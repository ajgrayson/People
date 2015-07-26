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
    
    func addPerson(name: String, addressBookRecordId: Int32?) -> Person? {
        if name == "" {
            return nil
        }
        
        let entity =  NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext)
        
        let date = NSDate()
        
        let person = Person(entity: entity!, insertIntoManagedObjectContext:managedObjectContext)
        
        person.setValue(date, forKey: "createdDate")
        person.setValue(name, forKey: "name")
        
        if addressBookRecordId != nil {
            person.setValue(NSNumber(int: addressBookRecordId!), forKey: "addressBookRecordId")
        }
        
        updatePerson(person)
        
        return person
    }
    
    func updatePerson(person : Person) -> Bool {
        let date = NSDate()
        
        person.setValue(date, forKey: "updatedDate")
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Could not save person")
            return false
        }
        return true
    }
    
    func getAllPeopleOrderedByName() -> [Person] {
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let fetchedResults = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Person]
            
            return fetchedResults
        } catch {
            print("Failed to get results")
            return [Person]()
        }
    }
    
    func getFavorites(favorites: Bool) -> [Person] {
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        if favorites {
            fetchRequest.predicate = NSPredicate(format: "favourite = %@", argumentArray: [NSNumber(int: 1)])
        } else {
            fetchRequest.predicate = NSPredicate(format: "favourite != %@", argumentArray: [NSNumber(int: 1)])
        }
        
        do {
            let fetchedResults = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Person]
            
            return fetchedResults
        } catch {
            print("Failed to get results")
            return [Person]()
        }
        
    }
    
    func doesPersonExist(addressBookRecordId: Int32) -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        fetchRequest.predicate = NSPredicate(format: "addressBookRecordId = %@", argumentArray: [NSNumber(int: addressBookRecordId)])
        
        do {
            let fetchedResults = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Person]
        
            return fetchedResults.count > 0
        } catch {
            print("Failed to find person")
            return false
        }
    }
    
}