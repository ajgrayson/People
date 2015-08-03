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
    //private var people = [Person]()
    
    private var peopleGroup1 = [Person]()
    
    private var peopleGroup2 = [Person]()
    
    private var personToView : Person?
    
    private var personService : PersonService!
    
    private var noteService : NoteService!
    
    private var reminderService : ReminderService!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personService = PersonService(context: managedContext)
        noteService = NoteService(context: managedContext)
        reminderService = ReminderService(context: managedContext)

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
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Favourites"
        } else {
            return "Others"
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return peopleGroup1.count
        }
        return peopleGroup2.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let p = getPerson(indexPath)
        
        if p.caption != nil && p.caption != "" {
            let cell = tableView.dequeueReusableCellWithIdentifier("personCell", forIndexPath: indexPath) as! PeopleListTableViewCell
            
            cell.nameLabel!.text = p.name
            cell.captionLabel!.text = p.caption
            
            if p.lastContactedDate != nil {
                cell.dayLabel.text = p.lastContactedDate!.relativeDay()
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "d";
                cell.dateLabel.text = dateFormatter.stringFromDate(p.lastContactedDate!)
                
                dateFormatter.dateFormat = "MMMM";
                cell.monthLabel.text = dateFormatter.stringFromDate(p.lastContactedDate!)
            } else {
                cell.dayLabel.text = ""
                cell.dateLabel.text = ""
                cell.monthLabel.text = ""
            }
            
            if p.image != nil {
                cell.photoView?.image = UIImage(data: p.image!)
            } else {
                cell.photoView?.image = UIImage(named: "Person")
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("personCell2", forIndexPath: indexPath) as! PeopleListTableViewCell2
            
            cell.nameLabel!.text = p.name
            
            if p.lastContactedDate != nil {
                cell.dayLabel.text = p.lastContactedDate!.relativeDay()
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "d";
                cell.dateLabel.text = dateFormatter.stringFromDate(p.lastContactedDate!)
                
                dateFormatter.dateFormat = "MMMM";
                cell.monthLabel.text = dateFormatter.stringFromDate(p.lastContactedDate!)
            } else {
                cell.dayLabel.text = ""
                cell.dateLabel.text = ""
                cell.monthLabel.text = ""
            }
            
            if p.image != nil {
                cell.photoView?.image = UIImage(data: p.image!)
            } else {
                cell.photoView?.image = UIImage(named: "Person")
            }
            
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 81
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
        peopleGroup1 = personService.getFavorites(true)
        peopleGroup2 = personService.getFavorites(false)
        tableView.reloadData()
    }
    
    func getPerson(indexPath: NSIndexPath) -> Person {
        let person : Person
        if indexPath.section == 0 {
            person = peopleGroup1[indexPath.row]
        } else {
            person = peopleGroup2[indexPath.row]
        }
        return person
    }
    
    func deleteRow(indexPath: NSIndexPath) {
        let person = getPerson(indexPath)
        displayDeleteConfirmation(person)
    }
    
    func viewRow(indexPath: NSIndexPath) {
        let person = getPerson(indexPath)
        
        personToView = person
        
        self.performSegueWithIdentifier("editPerson", sender: self)
    }
    
    func displayDeleteConfirmation(person: Person) {
        let alert = UIAlertController(title: "DELETE",
            message: "Are you sure you want to delete this person?",
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Yes",
            style: .Default,
            handler: { action in
                self.deletePerson(person)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {
            action in
                self.tableView.setEditing(false, animated: true)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func deletePerson(person: Person) {
        noteService.deleteNotesFor(person)
        reminderService.deleteRemindersFor(person)
        
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
        if(segue.identifier == "viewPerson" || segue.identifier == "viewPerson2") {
            let nvc = segue.destinationViewController as! PersonOverviewTableViewController
            
            let person = getPerson(self.tableView.indexPathsForSelectedRows!.first!)
            
            nvc.person = person
            nvc.managedContext = managedContext
        } else if segue.identifier == "addPerson" {
            let nvc = segue.destinationViewController as! PersonDetailTableViewController
            
            nvc.managedContext = managedContext
        } else if segue.identifier == "editPerson" {
            let nvc = segue.destinationViewController as! PersonDetailTableViewController
            
            let person = personToView
            
            nvc.person = person
            nvc.managedContext = managedContext
        }
    }

}
