//
//  EditNoteViewController.swift
//  people
//
//  Created by John Grayson on 19/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class EditNoteViewController: UIViewController {

    var note : NSManagedObject?
    
    var person : NSManagedObject!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBAction func saveNoteClicked(sender: AnyObject) {
        
        save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if(note != nil) {
            contentTextView.text = note!.valueForKey("content") as! String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func save() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let date = NSDate()
        
        if note == nil {
            let entity =  NSEntityDescription.entityForName("Note", inManagedObjectContext: managedContext)
            
            note = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            note!.setValue(date, forKey: "createdDate")
            
            var set = person.mutableSetValueForKey("notes")
            set.addObject(note!)
        }
        
        let content = contentTextView.text;
        
        note!.setValue(content, forKey: "content")
        note!.setValue(date, forKey: "updatedDate")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        self.navigationController?.popViewControllerAnimated(true);
    }

}
