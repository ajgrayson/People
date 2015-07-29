//
//  NotesTableViewController.swift
//  people
//
//  Created by John Grayson on 19/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {

    // passed in properties
    var managedContext : NSManagedObjectContext!
    
    var person : Person!
    
    // local properties
    private var notes = [Note]()
    
    private var noteService : NoteService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteService = NoteService(context: managedContext)

        configureTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPerson()
        loadNotes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath) as! NotesTableViewCell
        
        let content = notes[indexPath.row].content
        var date = notes[indexPath.row].date
        if date == nil {
            date = notes[indexPath.row].updatedDate
        }
        
        cell.noteLabel!.text = content
        cell.dateLabel!.text = date?.relativeTime.uppercaseString
        
        return cell
    }
    
    func loadPerson() {
        self.navigationItem.title = person.name
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func loadNotes() {
        notes = noteService.getAllNotesFor(person, orderedByDate: true)
        tableView.reloadData()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction] {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") {
            (action, indexPath) -> Void in
            self.deleteRow(indexPath)
        }
        
        return [deleteAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func deleteRow(indexPath: NSIndexPath) {
        let note = notes[indexPath.row]
        displayDeleteConfirmation(note)
    }
    
    func displayDeleteConfirmation(note: Note) {
        let alert = UIAlertController(title: "DELETE",
            message: "Are you sure you want to delete this note.",
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Yes",
            style: .Default,
            handler: { action in
                self.deleteNote(note)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {
            action in
            self.tableView.setEditing(false, animated: true)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }

    func deleteNote(note: Note) {
        noteService.deleteNote(note)
        loadNotes()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        let nvc = segue.destinationViewController as! NoteViewController
        
        if(segue.identifier == "editNote") {
            let note = notes[self.tableView.indexPathsForSelectedRows!.first!.row]
            nvc.note = note;
        }
        
        nvc.person = person;
        nvc.managedContext = managedContext
    }

}
