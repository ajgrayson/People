//
//  NoteTableViewController.swift
//  people
//
//  Created by John Grayson on 23/07/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var dateLabelCell: UITableViewCell!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func saveNoteClicked(sender: AnyObject) {
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
    
    private var datePickerIsOpen : Bool = false
    
    private var draftSaveTimer : NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteService = NoteService(context: managedContext)
        personService = PersonService(context: managedContext)
        personLastContactedService = PersonLastContactedService(context: managedContext)
        
        loadNote()
        
        datePicker.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        contentTextView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        draftSaveTimer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector("updateDraft"), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        draftSaveTimer.invalidate()
    }
    
    func textViewDidChange(textView: UITextView) {
        saveButton.enabled = true
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        updateDateLabel(sender.date)
        saveButton.enabled = true
    }
    
    func updateDateLabel(date: NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY h:mm a"
        dateLabel.text = dateFormatter.stringFromDate(date)
    }
    
    func loadNote() {
        if(note != nil) {
            loadNote(note!)
        } else {
            let draftNote = noteService.getDraft(person)
            if draftNote != nil {
                note = draftNote;
                loadNote(note!)
            } else {
                updateDateLabel(NSDate())
                contentTextView.becomeFirstResponder()
            }
        }
    }
    
    func loadNote(note: Note) {
        contentTextView.text = note.valueForKey("content") as! String
        
        // temp while date not always set
        if note.date != nil {
            datePicker.setDate(note.date!, animated: false)
            updateDateLabel(note.date!)
        } else {
            datePicker.setDate(note.updatedDate!, animated: false)
            updateDateLabel(note.updatedDate!)
        }
        
        saveButton.enabled = false
    }
    
    func updateDraft() {
        if save(false) {
            saveButton.enabled = false
        }
    }
    
    func save(draft: Bool) -> Bool {
        let content = contentTextView.text
        
        if content == nil || content == "" {
            return false
        }
        
        let date = datePicker.date
        
        if note == nil {
            note = noteService.addNote(content, toPerson: person)
        } else {
            note!.setValue(content, forKey: "content")
        }
        
        note?.date = date;
        note?.isDraft = draft
        
        let res = noteService.updateNote(note!)
        
        if res {
            personLastContactedService.updateLastContacted(person)
        }
        
        return res
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 2
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            toggleDatePicker()
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !datePickerIsOpen && indexPath.section == 1 && indexPath.row == 1 {
            cell.hidden = true
        }
    }
    
    func toggleDatePicker() {
        datePickerIsOpen = !datePickerIsOpen
        datePickerCell.hidden = !datePickerIsOpen
        dateLabelCell.selected = false
    }

}
