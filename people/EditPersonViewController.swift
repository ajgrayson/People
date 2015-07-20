//
//  ViewController.swift
//  people
//
//  Created by John Grayson on 19/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class EditPersonViewController: UIViewController {

    // passed in properties
    var managedContext : NSManagedObjectContext!
    
    var person : NSManagedObject?
    
    // local properties
    private var personService : PersonService!
    
    @IBOutlet weak var nameTextField: UITextField!

    @IBAction func saveButtonClicked(sender: UIBarButtonItem) {
        if save() {
            navigationController?.popViewControllerAnimated(false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personService = PersonService(context: managedContext)
        
        loadExistingPerson()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadExistingPerson() {
        if(person != nil) {
            nameTextField.text = person?.valueForKey("name") as! String!
        }
        
        nameTextField.becomeFirstResponder()
    }
    
    func save() -> Bool {
        let name = nameTextField.text;
        
        if(name == nil || name == "") {
            return false
        }
        
        if(person == nil) {
            person = personService.addPerson(name)
            return person != nil
        } else {
            person!.setValue(name, forKey: "name")
            return personService.updatePerson(person!)
        }
    }

}

