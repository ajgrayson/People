//
//  ReminderDetailsTableViewController.swift
//  people
//
//  Created by John Grayson on 1/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class ReminderDetailsTableViewController: UITableViewController {
    
    var context : NSManagedObjectContext!
    
    var person : Person!
    
    var reminder : Reminder?
    
    // local properties
    
    private var reminderService : ReminderService!
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        if save() {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reminderService = ReminderService(context: context)
        
        loadReminder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadReminder() {
        if reminder != nil {
            titleTextField.text = reminder?.title
            
            if reminder?.date != nil {
                datePicker.date = (reminder?.date)!
            } else {
                datePicker.date = NSDate()
            }
        }
    }
    
    func save() -> Bool {
        if titleTextField.text == nil || titleTextField.text == "" {
            return false
        }
        
        let title = titleTextField.text
        let date = datePicker.date
        
        if reminder == nil {
            reminder = reminderService.addReminder(title!, date: date, toPerson: person)
        } else {
            reminder?.title = title
            reminder?.date = date
            
            reminderService.updateReminder(reminder!)
        }
        
        return true;
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
