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
    
    func getAllNotesFor(person: Person, orderedByDate: Bool) -> [Note] {
        let fetchRequest = NSFetchRequest(entityName:"Note")
        
        fetchRequest.predicate = NSPredicate(format: "person = %@", argumentArray: [person])
        
        if orderedByDate {
            let sortDate = NSSortDescriptor(key: "date", ascending: false)
            fetchRequest.sortDescriptors = [sortDate]
        }
        
        do {
            let fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Note]
            
            return fetchedResults
        } catch {
            return [Note]()
        }

    }
    
    func getLatestNoteFor(person: Person) -> Note? {
        let fetchRequest = NSFetchRequest(entityName:"Note")
        
        fetchRequest.predicate = NSPredicate(format: "person = %@", argumentArray: [person])
        
        let sortDate = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDate]
        
        do {
            let fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Note]
            
            if fetchedResults.count > 0 {
                return fetchedResults.first
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func getDraft(person: Person) -> Note? {
        let fetchRequest = NSFetchRequest(entityName:"Note")
        
        fetchRequest.predicate = NSPredicate(format: "person = %@ and draft=%@", argumentArray: [person, true])
        
        do {
            let fetchedResults = try context.executeFetchRequest(fetchRequest) as! [Note]
            
            if fetchedResults.count > 0 {
                return fetchedResults.first!
            }
            
            return nil
        } catch {
            return nil
        }

    }
    
    func deleteNote(note: Note) -> Bool {
        context.deleteObject(note)
        
        do {
            try context.save()
            return true
        } catch {
            print("Could not save")
            return false
        }
    }
    
    func deleteNotesFor(person: Person) {
        let notes = getAllNotesFor(person, orderedByDate: false)
        for note in notes {
            deleteNote(note)
        }
    }
    
    func addNote(content: String, toPerson: Person) -> Note? {
        let date = NSDate()
        
        if content == "" {
            return nil
        }
        
        let entity =  NSEntityDescription.entityForName("Note", inManagedObjectContext: context)
        
        let note = Note(entity: entity!, insertIntoManagedObjectContext:context)
        note.createdDate = date
        note.content = content
        note.date = date // default
        
        let set = toPerson.mutableSetValueForKey("notes")
        set.addObject(note)
        
        updateNote(note)
        
        return note
    }
    
    func updateNote(note: Note) -> Bool {
        note.updatedDate = NSDate()
        
        do {
            try context.save()
            return true
        } catch {
            print("Could not save note")
            return false
        }
    }
    
}