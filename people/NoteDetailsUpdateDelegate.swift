//
//  NoteDetailsUpdateProtocol.swift
//  people
//
//  Created by John Grayson on 28/07/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import Foundation

protocol NoteDetailsUpdateDelegate {
    
    func noteDetailsDidChange(details: NoteDetails)
    
}