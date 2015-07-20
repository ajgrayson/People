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
    private var people = [NSManagedObject]()
    
    private var personToEdit : NSManagedObject?
    
    private var personService : PersonService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personService = PersonService(context: managedContext)

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
        
        var name = people[indexPath.row].valueForKey("name") as! String?
        
        cell.nameLabel!.text = name!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject] {
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") {
            (action, indexPath) -> Void in
            self.deleteRow(indexPath)
        }
        
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") {
            (action, indexPath) -> Void in
            self.editRow(indexPath)
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
        var person = people[indexPath.row]
        
        managedContext.deleteObject(person)
        
        // todo - get all notes and delete those too.
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        loadPeople()
    }
    
    func editRow(indexPath: NSIndexPath) {
        var person = people[indexPath.row]
        
        personToEdit = person
        
        self.performSegueWithIdentifier("editPerson", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "viewNotes") {
            var nvc = segue.destinationViewController as! UINavigationController
            var nvc2 = nvc.childViewControllers.first as! NotesTableViewController
            
            var person = people[self.tableView.indexPathsForSelectedRows()!.first!.row]
            
            nvc2.person = person;
            nvc2.managedContext = self.managedContext
        }
        else if(segue.identifier == "editPerson") {
            var nvc = segue.destinationViewController as! EditPersonViewController
            nvc.person = personToEdit
        }
        
        if(segue.identifier == "addPerson" || segue.identifier == "editPerson") {
            var nvc = segue.destinationViewController as! EditPersonViewController
            nvc.managedContext = self.managedContext
        }
        
    }

}
