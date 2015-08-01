//
//  PersonOverviewTableViewController.swift
//  people
//
//  Created by John Grayson on 1/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class PersonOverviewTableViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    // passed in properties
    var managedContext : NSManagedObjectContext!
    
    var person : Person!
    
    // local properties
    private var personService : PersonService!
    
    private var noteService : NoteService!
    
    private var lastNote : Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        personService = PersonService(context: managedContext)
        noteService = NoteService(context: managedContext)
        
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateDisplay() {
        if person.image != nil {
            imageView.image = UIImage(data: person.image!)
        } else {
            imageView.image = UIImage(named: "Person")
        }
        
        nameLabel.text = person.name
        descriptionLabel.text = person.caption
        
        lastNote = noteService.getLatestNoteFor(person)
        if lastNote != nil {
            noteLabel.text = lastNote?.content
        }
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 && lastNote != nil {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEEE, d MMMM YYYY"
            return formatter.stringFromDate(lastNote!.date ?? lastNote!.updatedDate!)
        }
        return ""
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 || indexPath.section == 2 {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewNotes" {
            let nvc = segue.destinationViewController as! NotesTableViewController
            
            nvc.person = person
            nvc.managedContext = managedContext
        }
        else if segue.identifier == "viewReminders" {
            let nvc2 = segue.destinationViewController as! RemindersTableViewController
            
            nvc2.person = person
            nvc2.managedContext = managedContext
        }
        else if segue.identifier == "editPerson" {
            let nvc = segue.destinationViewController as! PersonDetailTableViewController
            
            nvc.person = person
            nvc.managedContext = managedContext
        }
    }

}
