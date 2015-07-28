//
//  NoteViewController.swift
//  people
//
//  Created by John Grayson on 28/07/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController, UITextViewDelegate, NoteDetailsUpdateDelegate {

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var detailsButtonClicked: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func saveButtonClicked(sender: AnyObject) {
        if save(false) {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // passed in properties
    var note : Note?
    
    var person : Person!
    
    var managedContext : NSManagedObjectContext!
    
    // local properties
    private var noteService : NoteService!
    
    private var personService : PersonService!
    
    private var personLastContactedService : PersonLastContactedService!
    
    private var draftSaveTimer : NSTimer!
    
    private var date : NSDate?
    
    private var dateOverride : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteService = NoteService(context: managedContext)
        personService = PersonService(context: managedContext)
        personLastContactedService = PersonLastContactedService(context: managedContext)
        
        loadNote()
        
        contentTextView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        draftSaveTimer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector("onDraftSaveTimer"), userInfo: nil, repeats: true)
        
        registerForNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        draftSaveTimer.invalidate()
        unregisterForNotifications()
    }
    
    func registerForNotifications() {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unregisterForNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    func keyboardWasShown(notification: NSNotification) {
//        NSDictionary* info = [aNotification userInfo];
//        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//        
//        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//        scrollView.contentInset = contentInsets;
//        scrollView.scrollIndicatorInsets = contentInsets;
//        
//        // If active text field is hidden by keyboard, scroll it so it's visible
//        // Your app might not need or want this behavior.
//        CGRect aRect = self.view.frame;
//        aRect.size.height -= kbSize.height;
//        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//            [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
//        }
        
        let info : NSDictionary? = notification.userInfo
        let size : CGSize = (info!.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size)!
        
        let inset : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, size.height, 0.0)
        
        contentTextView.contentInset = inset;
        contentTextView.scrollIndicatorInsets = inset;
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        contentTextView.contentInset = UIEdgeInsetsZero
        contentTextView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    
    func noteDetailsDidChange(details: NoteDetails) {
        dateOverride = details.date
        saveButton.enabled = true
    }
    
    func onDraftSaveTimer() {
        if (note == nil && contentTextView.text != nil) || note != nil {
            if save(false) {
                saveButton.enabled = false
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        saveButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNote() {
        if(note != nil) {
            loadNote(note!)
        } else {
            date = NSDate() // set to now by default
            contentTextView.becomeFirstResponder()
        }
    }
    
    func loadNote(note: Note) {
        contentTextView.text = note.content
        date = note.date
        saveButton.enabled = false
    }
    
    func save(draft: Bool) -> Bool {
        let content = contentTextView.text
        
        if content == nil || content == "" {
            return false
        }
        
        if note == nil {
            note = noteService.addNote(content, toPerson: person)
        } else {
            note!.content = content
        }
        
        note?.date = dateOverride ?? date;
        note?.isDraft = draft
        
        let res = noteService.updateNote(note!)
        if res {
            personLastContactedService.updateLastContacted(person)
        }
        
        return res
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "noteDetails" {
            let nvc = segue.destinationViewController as! AppNavigationController
            let nvc2 = nvc.childViewControllers.first as! NoteDetailsTableViewController
            
            nvc2.date = dateOverride ?? date
            nvc2.delegate = self
        }
    }

}
