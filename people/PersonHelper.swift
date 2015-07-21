//
//  PersonHelper.swift
//  people
//
//  Created by John Grayson on 21/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import Foundation

class PersonHelper : NSObject {
    
    func buildFullName(firstName: String?, lastName: String?) -> String {
        
        if firstName == nil && lastName == nil {
            return ""
        }
        
        var name = ""
        if firstName != nil {
            name = firstName!
        }
        if lastName != nil {
            if name != "" {
                name += " "
            }
            name += lastName!
        }
        
        return name
    }
    
}