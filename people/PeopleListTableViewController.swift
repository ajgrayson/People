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

    var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPeople()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
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
        
        return [deleteAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func loadPeople() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Person")
        
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        
        if let results = fetchedResults {
            people = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func deleteRow(indexPath: NSIndexPath) {
        //notes[indexPath.row].deleted = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        var note = people[indexPath.row]
        
        managedContext.deleteObject(note)
        
        // todo - get all notes and delete those too.
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        //tableView.reloadData()
        
        loadPeople()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "viewNotes") {
            var nvc = segue.destinationViewController as! UINavigationController
            var nvc2 = nvc.childViewControllers.first as! NotesTableViewController
            
            var person = people[self.tableView.indexPathsForSelectedRows()!.first!.row]
            
            nvc2.person = person;
        }
    }

}
