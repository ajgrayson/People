//
//  RemindersTableViewController.swift
//  people
//
//  Created by John Grayson on 1/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class RemindersTableViewController: UITableViewController {

    // passed in properties
    var managedContext : NSManagedObjectContext!
    
    var person : Person!
    
    // local properties
    private var reminders = [Reminder]()
    
    private var reminderService : ReminderService!
    
    private var notificationService : NotificationService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reminderService = ReminderService(context: managedContext)
        notificationService = NotificationService()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadReminders()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadReminders() {
        reminders = reminderService.getAllRemindersFor(person, orderedByDate: true)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminders.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath) as! ReminderTableViewCell

        let reminder = reminders[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM h:mm a"
        
        cell.titleLabel.text = reminder.title
        cell.dateLabel.text = dateFormatter.stringFromDate(reminder.date!)

        return cell
    }
    
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
        let reminder = reminders[indexPath.row]
        displayDeleteConfirmation(reminder)
    }
    
    func displayDeleteConfirmation(reminder: Reminder) {
        let alert = UIAlertController(title: "DELETE",
            message: "Are you sure you want to delete this reminder.",
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Yes",
            style: .Default,
            handler: { action in
                self.deleteReminder(reminder)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {
            action in
            self.tableView.setEditing(false, animated: true)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteReminder(reminder: Reminder) {
        if reminder.notificationId != nil {
            notificationService.cancelNotification(reminder.notificationId!)
        }
        reminderService.deleteReminder(reminder)
        loadReminders()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nvc = segue.destinationViewController as! ReminderDetailsTableViewController
        
        nvc.person = person
        nvc.context = managedContext
        
        if segue.identifier == "viewReminder" {
            let reminder = reminders[(tableView.indexPathForSelectedRow?.row)!]
            nvc.reminder = reminder
        }
    }

}
