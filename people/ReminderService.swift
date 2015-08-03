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
    
    func deleteReminder(reminder: Reminder) -> Bool {
        context.deleteObject(reminder)
        
        do {
            try context.save()
            return true
        } catch {
            print("Could not save")
            return false
        }
    }
    
    func deleteRemindersFor(person: Person) {
        let reminders = getAllRemindersFor(person, orderedByDate: false)
        for reminder in reminders {
            deleteReminder(reminder)
        }
    }
    
    func addReminder(title: String, date: NSDate, id: String, toPerson: Person) -> Reminder? {
        let dateNow = NSDate()
        
        if title == "" {
            return nil
        }
        
        let entity =  NSEntityDescription.entityForName("Reminder", inManagedObjectContext: context)
        
        let reminder = Reminder(entity: entity!, insertIntoManagedObjectContext:context)
        reminder.createdDate = dateNow
        reminder.title = title
        reminder.date = date // default
        reminder.notificationId = id
        
        let set = toPerson.mutableSetValueForKey("reminders")
        set.addObject(reminder)
        
        updateReminder(reminder)
        
        return reminder
    }
    
    func updateReminder(reminder: Reminder) -> Bool {
        reminder.updatedDate = NSDate()
        
        do {
            try context.save()
            return true
        } catch {
            print("Could not save reminder")
            return false
        }
    }
    
}