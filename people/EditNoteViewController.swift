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

    // passed in properties
    var note : Note?
    
    var person : Person!
    
    var managedContext : NSManagedObjectContext!
    
    // local properties
    private var noteService : NoteService!
    
    private var personService : PersonService!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func saveNoteClicked(sender: AnyObject) {
        if save() {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteService = NoteService(context: managedContext)
        personService = PersonService(context: managedContext)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        loadNote()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNote() {
        if(note != nil) {
            contentTextView.text = note!.valueForKey("content") as! String
            datePicker.setDate(note!.updatedDate!, animated: false)
        }
        
        contentTextView.becomeFirstResponder()
    }
    
    func save() -> Bool {
        let content = contentTextView.text
        
        if content == nil || content == "" {
            return false
        }
        
        let date = datePicker.date
        
        personService.setLastContactedDate(person, date: date)
        
        if note == nil {
            note = noteService.addNote(content, toPerson: person)
        } else {
            note!.setValue(content, forKey: "content")
        }
        
        note?.updatedDate = date;
        
        return noteService.updateNote(note!)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo!
        var kbRect = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue
        kbRect = self.view.convertRect(kbRect!, fromView: nil)
        
        let edgeInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height + 40, 0.0)
        scrollView.contentInset = edgeInsets
        scrollView.scrollIndicatorInsets = edgeInsets
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
//        let edgeInsets : UIEdgeInsets = UIEdgeInsetsZero
//        scrollView.contentInset = edgeInsets
//        scrollView.scrollIndicatorInsets = edgeInsets
    }
    
}
