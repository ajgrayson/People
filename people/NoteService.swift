//
//  NoteService.swift
//  people
//
//  Created by John Grayson on 21/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import Foundation
import CoreData

class NoteService : NSObject {
    
    var context : NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getAllNotesFor(person: NSManagedObject, orderedByDate: Bool) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName:"Note")
        
        fetchRequest.predicate = NSPredicate(format: "person = %@", argumentArray: [person])
        
        if orderedByDate {
            let sortDate = NSSortDescriptor(key: "createdDate", ascending: false)
            fetchRequest.sortDescriptors = [sortDate]
        }
        
        var error: NSError?
        
        let fetchedResults = context.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        
        if let results = fetchedResults {
            return results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
            return [NSManagedObject]()
        }

    }
    
    func deleteNote(note: NSManagedObject) -> Bool {
        context.deleteObject(note)
        
        var error: NSError?
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            return false
        }
        return true
    }
    
    func deleteNotesFor(person: NSManagedObject) {
        var notes = getAllNotesFor(person, orderedByDate: false)
        for note in notes {
            deleteNote(note)
        }
    }
    
    func addNote(content: String, toPerson: NSManagedObject) -> NSManagedObject? {
        let date = NSDate()
        
        if content == "" {
            return nil
        }
        
        let entity =  NSEntityDescription.entityForName("Note", inManagedObjectContext: context)
        
        var note = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:context)
        note.setValue(date, forKey: "createdDate")
        note.setValue(content, forKey: "content")
        
        var set = toPerson.mutableSetValueForKey("notes")
        set.addObject(note)
        
        updateNote(note)
        
        return note
    }
    
    func updateNote(note: NSManagedObject) -> Bool {
        let date = NSDate()
        
        note.setValue(date, forKey: "updatedDate")
        
        var error: NSError?
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            return false
        }
        return true
    }
    
}