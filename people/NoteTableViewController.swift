//
//  NoteTableViewController.swift
//  people
//
//  Created by John Grayson on 23/07/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    
    @IBAction func saveNoteClicked(sender: AnyObject) {
        if save() {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteService = NoteService(context: managedContext)
        personService = PersonService(context: managedContext)
        
        loadNote()
        
        datePicker.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        updateDate(sender.date)
    }
    
    func updateDate(date: NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, YYYY h:mma"
        dateLabel.text = dateFormatter.stringFromDate(date)
    }
    
    func loadNote() {
        if(note != nil) {
            contentTextView.text = note!.valueForKey("content") as! String
            datePicker.setDate(note!.updatedDate!, animated: false)
            updateDate(note!.updatedDate!)
        } else {
            updateDate(NSDate())
            contentTextView.becomeFirstResponder()
        }
    }
    
    func save() -> Bool {
        let content = contentTextView.text
        
        if content == nil || content == "" {
            return false
        }
        
        let date = datePicker.date
        
        personService.setLastContactedDate(person, date: date)
        
        if note == nil {
            note = noteService.addNote(content, toPerson: person)
        } else {
            note!.setValue(content, forKey: "content")
        }
        
        note?.updatedDate = date;
        
        return noteService.updateNote(note!)
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
    
    private var datePickerIsOpen : Bool = false
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            datePickerIsOpen = !datePickerIsOpen
            datePickerCell.hidden = !datePickerIsOpen
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !datePickerIsOpen && indexPath.section == 1 && indexPath.row == 1 {
            cell.hidden = true
        }
    }

}
