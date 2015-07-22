//
//  PersonDetailTableViewController.swift
//  people
//
//  Created by John Grayson on 22/07/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData
import AddressBookUI
import AddressBook

class PersonDetailTableViewController: UITableViewController, ABPeoplePickerNavigationControllerDelegate {

    // passed in properties
    var managedContext : NSManagedObjectContext!
    
    var person : Person?
    
    // local properties
    private var personService : PersonService!
    
    private let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    
    private var addressBookRecordId : ABRecordID?
    
    @IBAction func saveButtonClick(sender: AnyObject) {
        if save() {
            self.navigationController?.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBOutlet weak var contactRecordNameLabel: UILabel!
    @IBOutlet weak var viewContactCell: UITableViewCell!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        personService = PersonService(context: managedContext)
        
        displayPerson()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
            //cell.userInteractionEnabled = true
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            //cell.userInteractionEnabled = false
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 2
        default:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            clickedLinkToContactRow()
        }
    }
    
    func removeContactLink() {
        addressBookRecordId = nil
        showLinkToContact()
    }
    
    func displayPerson() {
        if person != nil {
            nameTextField.text = person!.name
            //descriptionTextField.text = person!.note
            
            if person!.isLinkedToAddressBook {
                showUnlinkContact()
                addressBookRecordId = person?.addressBookRecordId!.intValue
            } else {
                showLinkToContact()
            }
        } else {
            showFindContact()
        }
        
//        if nameTextField.enabled {
//            nameTextField.becomeFirstResponder()
//        } else {
//            descriptionTextField.becomeFirstResponder()
//        }
    }
    
    func showLinkToContact() {
        contactRecordNameLabel.text = "Link to Contact"
        contactRecordNameLabel.textColor = UIColor.blueColor()
        viewContactCell.selected = false
        nameTextField.enabled = true
    }
    
    func showUnlinkContact() {
        contactRecordNameLabel.text = "Remove"
        contactRecordNameLabel.textColor = UIColor.redColor()
        viewContactCell.selected = false
        nameTextField.enabled = false
    }
    
    func showFindContact() {
        contactRecordNameLabel.text = "Find Contact in Address Book"
        contactRecordNameLabel.textColor = UIColor.grayColor()
        viewContactCell.selected = false
        nameTextField.enabled = true
    }
    
    func clickedLinkToContactRow() {
        if addressBookRecordId != nil {
            removeContactLink()
        } else {
            openLinkToAddressBook()
        }
    }
    
    func viewAddressBookContact() {
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
    
    func openLinkToAddressBook() {
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
    
    func save() -> Bool {
        if nameTextField.text == nil || nameTextField.text == "" {
            return false
        }
    
        let name = nameTextField.text
        
        if person == nil {
            person = personService.addPerson(name!, addressBookRecordId: addressBookRecordId)
        } else {
            if addressBookRecordId != nil {
                person?.addressBookRecordId = NSNumber(int: addressBookRecordId!)
            } else {
                person?.addressBookRecordId = nil
            }
            person?.name = name
            personService.updatePerson(person!)
        }
        
        return true
    }
    
    // address picker
    
    func lookupAddressBook() {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self;
        
        self.presentViewController(picker, animated: true) { () -> Void in
            
        }
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        
        let recordId = ABRecordGetRecordID(person)
        
        if !personService.doesPersonExist(recordId) {
            var firstName : String?
            let rawFirstName = ABRecordCopyValue(person, kABPersonFirstNameProperty)
            if rawFirstName != nil {
                firstName = rawFirstName.takeRetainedValue() as? String
            }
            
            var lastName : String?
            let rawLastName = ABRecordCopyValue(person, kABPersonLastNameProperty)
            if rawLastName != nil {
                lastName = rawLastName.takeRetainedValue() as? String
            }
            
            let name = PersonHelper().buildFullName(firstName, lastName: lastName)
            
            addressBookRecordId = recordId
            
            nameTextField.text = name
            nameTextField.enabled = false
            
            showUnlinkContact()
            
            closeAddressPicker()
            
            tableView.reloadData()
        } else {
            closeAddressPicker()
            displayAlreadyExistsAlert()
        }
    }
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController) {
        closeAddressPicker()
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        
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
            
            if record != nil {
                let personViewController = ABPersonViewController()
                personViewController.displayedPerson = record!
                
                self.navigationController?.pushViewController(personViewController, animated: true)
            } else {
                self.showMissingContactError()
            }
        })
        
    }
    
    func promptForAddressBookRequestAccess() {
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
    
    func showMissingContactError() {
        let missingContactAlert = UIAlertController(title: "Missing Contact",
            message: "The contact can't be found in your address book. It's likely they've its been deleted.",
            preferredStyle: .Alert)
        
        missingContactAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        presentViewController(missingContactAlert, animated: true, completion: nil)
    }

}
