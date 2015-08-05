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
    
    private var notificationService : NotificationService!
    
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
        notificationService = NotificationService()
        
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
        let id = NSUUID().UUIDString
        
        if reminder == nil {
            reminder = reminderService.addReminder(title!, date: date, id: id, toPerson: person)
          
            notificationService.addNotification(person!.name!, body: title!, date: date, id: id)
        } else {
            reminder!.title = title
            reminder!.date = date
            
            if reminder!.notificationId != nil {
                notificationService.cancelNotification(reminder!.notificationId!)
            }
            
            notificationService.addNotification(person!.name!, body: title!, date: date, id: id)
            
            reminder!.notificationId = id
            
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
}
