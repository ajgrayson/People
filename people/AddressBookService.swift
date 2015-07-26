//
//  AddressBookService.swift
//  people
//
//  Created by John Grayson on 21/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import Foundation
import AddressBook
import UIKit

class AddressBookService : NSObject {
    
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    
    override init() {
        super.init()
    }
    
    func lookupAddressBookRecord(recordId: Int32, result: ABRecord? -> Void) {
        checkAuthorization({() -> Void in
            let record = ABAddressBookGetPersonWithRecordID(self.addressBookRef, recordId)
            if record != nil {
                result(record.takeUnretainedValue())
            } else {
                result(nil)
            }
        }, deniedBlock: {() -> Void in
            result(nil)
        })
    }
    
    func checkAuthorization(successBlock: Void -> Void, deniedBlock: Void -> Void) {
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            //1
            deniedBlock()
        case .Authorized:
            //2
            successBlock()
        case .NotDetermined:
            //3
            promptForAddressBookRequestAccess(successBlock, deniedBlock: deniedBlock)
        }
    }
    
    func promptForAddressBookRequestAccess(successBlock: Void -> Void, deniedBlock: Void -> Void) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    deniedBlock()
                } else {
                    successBlock()
                }
            }
        }
    }
    
}