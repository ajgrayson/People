//
//  PeopleListTableViewController.swift
//  people
//
//  Created by John Grayson on 19/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData
import AddressBookUI
import AddressBook

class PeopleListTableViewController: UITableViewController, ABPeoplePickerNavigationControllerDelegate {

    // passed in properties
    var managedContext : NSManagedObjectContext!
    
    // local properties
    private var people = [NSManagedObject]()
    
    private var personToView : NSManagedObject?
    
    private var personService : PersonService!
    
    private let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    
    @IBAction func addPersonClicked(sender: AnyObject) {
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            //1
            self.displayCantAddContactAlert()
        case .Authorized:
            //2
            lookupAddressBook()
        case .NotDetermined:
            //3
            promptForAddressBookRequestAccess()
        }
    }
    
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
        
        let p = PersonModel(person: people[indexPath.row])
        
        cell.nameLabel!.text = p.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject] {
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") {
            (action, indexPath) -> Void in
            self.deleteRow(indexPath)
        }
        
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "View") {
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
        var person = people[indexPath.row]
        
        managedContext.deleteObject(person)
        
        // todo - get all notes and delete those too.
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        loadPeople()
    }
    
    func viewRow(indexPath: NSIndexPath) {
        var person = people[indexPath.row]
        
        personToView = person
        
        var recordId = person.valueForKey("addressBookRecordId")?.intValue
        
        viewPerson(recordId!)
        
        //self.performSegueWithIdentifier("viewPerson", sender: self)
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
    }
    
    // address picker
    
    func lookupAddressBook() {
        var picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self;
        
        // clear it
        //addressBookRecordId = nil
        //addressBookRecord = nil
        //nameTextField.text = ""
        
        self.presentViewController(picker, animated: true) { () -> Void in
            
        }
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        
        var addressBookRecordId = ABRecordGetRecordID(person)
        
        if !personService.doesPersonExist(addressBookRecordId) {
            var firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue() as! String
            
            var lastName = ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue() as! String
            
            var name = PersonHelper().buildFullName(firstName, lastName: lastName)
            
            var person = personService.addPerson(name, addressBookRecordId: addressBookRecordId)
            
            closeAddressPicker()
            
            tableView.reloadData()
        } else {
            closeAddressPicker()
            displayAlreadyExistsAlert()
        }
    }
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
        closeAddressPicker()
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        
    }
    
    func closeAddressPicker() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func displayAlreadyExistsAlert() {
        let cantAddContactAlert = UIAlertController(title: "Contact Already Exists",
            message: "This contact has already been added.",
            preferredStyle: .Alert)
        
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        self.presentViewController(cantAddContactAlert, animated: true, completion: nil)
    }
    
    func viewPerson(addressBookRecordId: Int32) {
        
        AddressBookService().lookupAddressBookRecord(addressBookRecordId, result: {(record: ABRecord?) -> Void in
            
            let personViewController = ABPersonViewController()
            personViewController.displayedPerson = record
            
            self.navigationController?.pushViewController(personViewController, animated: true)
        })
        
    }
    
    func promptForAddressBookRequestAccess() {
        var err: Unmanaged<CFError>? = nil
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    // 1
                    self.displayCantAddContactAlert()
                } else {
                    // 2
                    self.lookupAddressBook()
                }
            }
        }
    }
    
    func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func displayCantAddContactAlert() {
        let cantAddContactAlert = UIAlertController(title: "Cannot Add Contact",
            message: "You must give the app permission to add the contact first.",
            preferredStyle: .Alert)
        
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
            style: .Default,
            handler: { action in
                self.openSettings()
        }))
        
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(cantAddContactAlert, animated: true, completion: nil)
    }

}
