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

    @IBOutlet weak var nameTextField: UITextField!
    
    var person : NSManagedObject?
    
    @IBAction func saveButtonClicked(sender: UIBarButtonItem) {
        save();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(person != nil) {
            nameTextField.text = person?.valueForKey("name") as! String!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save() {
        let name = nameTextField.text;
        
        if(name == nil || name == "") {
            return
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        var date = NSDate()
        
        if person == nil {
            let entity =  NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
            person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            
            person!.setValue(date, forKey: "createdDate")
        }
        
        person!.setValue(name, forKey: "name")
        person!.setValue(date, forKey: "updatedDate")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        self.navigationController?.popViewControllerAnimated(false);
    }

}

