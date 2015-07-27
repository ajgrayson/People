//
//  NoteViewController.swift
//  people
//
//  Created by John Grayson on 28/07/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController, UITextViewDelegate, NoteDetailsUpdateDelegate {

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var detailsButtonClicked: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func saveButtonClicked(sender: AnyObject) {
        if save(false) {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // passed in properties
    var note : Note?
    
    var person : Person!
    
    var managedContext : NSManagedObjectContext!
    
    // local properties
    private var noteService : NoteService!
    
    private var personService : PersonService!
    
    private var personLastContactedService : PersonLastContactedService!
    
    private var draftSaveTimer : NSTimer!
    
    private var date : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteService = NoteService(context: managedContext)
        personService = PersonService(context: managedContext)
        personLastContactedService = PersonLastContactedService(context: managedContext)
        
        loadNote()
        
        contentTextView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        draftSaveTimer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector("onDraftSaveTimer"), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        draftSaveTimer.invalidate()
    }
    
    func noteDetailsDidChange(details: NoteDetails) {
        date = details.date
    }
    
    func onDraftSaveTimer() {
        if (note == nil && contentTextView.text != nil) || note != nil {
            if save(false) {
                saveButton.enabled = false
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        saveButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNote() {
        if(note != nil) {
            loadNote(note!)
        } else {
            date = NSDate() // set to now by default
            contentTextView.becomeFirstResponder()
        }
    }
    
    func loadNote(note: Note) {
        contentTextView.text = note.content
        date = note.date
        saveButton.enabled = false
    }
    
    func save(draft: Bool) -> Bool {
        let content = contentTextView.text
        
        if content == nil || content == "" {
            return false
        }
        
        if note == nil {
            note = noteService.addNote(content, toPerson: person)
        } else {
            note!.content = content
        }
        
        note?.date = date;
        note?.isDraft = draft
        
        let res = noteService.updateNote(note!)
        if res {
            personLastContactedService.updateLastContacted(person)
        }
        
        return res
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "noteDetails" {
            let nvc = segue.destinationViewController as! AppNavigationController
            let nvc2 = nvc.childViewControllers.first as! NoteDetailsTableViewController
            
            nvc2.date = date
            nvc2.delegate = self
        }
    }

}