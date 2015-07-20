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

    var notes = [NSManagedObject]()
    
    var person : NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        configureTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadNotes()
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
        return notes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath) as! NotesTableViewCell
        
        var content = notes[indexPath.row].valueForKey("content") as! String?
        
        cell.noteLabel!.text = content!
        
        return cell
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func loadNotes() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Note")
        fetchRequest.predicate = NSPredicate(format: "person = %@", argumentArray: [person])
        
        let sortDate = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDate]
        
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        
        if let results = fetchedResults {
            notes = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
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
    
    func deleteRow(indexPath: NSIndexPath) {
        //notes[indexPath.row].deleted = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        var note = notes[indexPath.row]
        
        managedContext.deleteObject(note)
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        //tableView.reloadData()
        
        loadNotes()
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        //if(segue.identifier == "viewNotes") {
        var nvc = segue.destinationViewController as! UINavigationController
        var nvc2 = nvc.childViewControllers.first as! EditNoteViewController
        
        if(segue.identifier == "editNote") {
            var note = notes[self.tableView.indexPathsForSelectedRows()!.first!.row]
            
            nvc2.note = note;
        }
        nvc2.person = person;
    
        //}
    }

}
