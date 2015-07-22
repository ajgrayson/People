//
//  EditNoteViewController.swift
//  people
//
//  Created by John Grayson on 19/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class EditNoteViewController: UIViewController {

    // passed in properties
    var note : Note?
    
    var person : Person!
    
    var managedContext : NSManagedObjectContext!
    
    // local properties
    private var noteService : NoteService!
    
    private var personService : PersonService!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBAction func saveNoteClicked(sender: AnyObject) {
        if save() {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteService = NoteService(context: managedContext)
        personService = PersonService(context: managedContext)
        
        loadNote()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNote() {
        if(note != nil) {
            contentTextView.text = note!.valueForKey("content") as! String
        }
        
        contentTextView.becomeFirstResponder()
    }
    
    func save() -> Bool {
        let content = contentTextView.text
        
        if content == nil || content == "" {
            return false
        }
        
        personService.setLastContactedDate(person, date: NSDate())
        
        if note == nil {
            note = noteService.addNote(content, toPerson: person)
            return note != nil
        } else {
            note!.setValue(content, forKey: "content")
            return noteService.updateNote(note!)
        }
    }

}
