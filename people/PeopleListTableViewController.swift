//
//  PeopleListTableViewController.swift
//  people
//
//  Created by John Grayson on 19/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class PeopleListTableViewController: UITableViewController {

    // passed in properties
    var managedContext : NSManagedObjectContext!
    
    // local properties
    private var people = [Person]()
    
    private var personToView : Person?
    
    private var personService : PersonService!
    
    private var noteService : NoteService!
    
    @IBAction func addPersonClicked(sender: AnyObject) {
//        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
//        
//        switch authorizationStatus {
//        case .Denied, .Restricted:
//            //1
//            self.displayCantAddContactAlert()
//        case .Authorized:
//            //2
//            lookupAddressBook()
//        case .NotDetermined:
//            //3
//            promptForAddressBookRequestAccess()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personService = PersonService(context: managedContext)
        noteService = NoteService(context: managedContext)

        // hides the extra lines
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPeople()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("personCell", forIndexPath: indexPath) as! PeopleListTableViewCell
        
        let p : Person = people[indexPath.row]
    
        cell.nameLabel!.text = p.name
        cell.timeLabel!.text = p.timeSinceLastContact
        cell.captionLabel!.text = p.caption
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") {
            (action, indexPath) -> Void in
            self.deleteRow(indexPath)
        }
        
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") {
            (action, indexPath) -> Void in
            self.viewRow(indexPath)
        }
        
        return [deleteAction, editAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func loadPeople() {
        people = personService.getAllPeopleOrderedByName()
        tableView.reloadData()
    }
    
    func deleteRow(indexPath: NSIndexPath) {
        let person = people[indexPath.row]
        displayDeleteConfirmation(person)
    }
    
    func viewRow(indexPath: NSIndexPath) {
        let person = people[indexPath.row]
        
        personToView = person
        
        self.performSegueWithIdentifier("editPerson", sender: self)
    }
    
    func displayDeleteConfirmation(person: Person) {
        let alert = UIAlertController(title: "Delete Person",
            message: "Are you sure you want to delete this person.",
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {
            action in
                self.tableView.setEditing(false, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes",
            style: .Default,
            handler: { action in
                self.deletePerson(person)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func deletePerson(person: Person) {
        noteService.deleteNotesFor(person)
        
        managedContext.deleteObject(person)
        
        do {
            try managedContext.save()
        } catch {
            print("Save failed")
        }
        
        loadPeople()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "viewNotes") {
            let nvc = segue.destinationViewController as! UINavigationController
            let nvc2 = nvc.childViewControllers.first as! NotesTableViewController
            
            let person = people[self.tableView.indexPathsForSelectedRows!.first!.row]
            
            nvc2.person = person
            nvc2.managedContext = self.managedContext
            nvc2.managedContext = managedContext
        } else if segue.identifier == "addPerson" {
            let nvc = segue.destinationViewController as! UINavigationController
            let nvc2 = nvc.childViewControllers.first as! PersonDetailTableViewController
            
            //nvc2.person = person
            nvc2.managedContext = managedContext
        } else if segue.identifier == "editPerson" {
            let nvc = segue.destinationViewController as! UINavigationController
            let nvc2 = nvc.childViewControllers.first as! PersonDetailTableViewController
            
            let person = personToView
            
            nvc2.person = person
            nvc2.managedContext = managedContext
        }
    }

}
