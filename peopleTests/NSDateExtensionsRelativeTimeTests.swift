//
//  NSDateExtensionsTests.swift
//  people
//
//  Created by John Grayson on 26/07/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import XCTest
import people

class NSDateExtensionsRelativeTimeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test1HourAgoReturnsToday() {
        let date = dateFromString("2015-01-20 09:00:00")
        let date2 = dateFromString("2015-01-20 10:00:00")
        
        let res = date.relativeTimeFrom(date2)
        
        XCTAssert(res == "Today")
    }
    
    func test12amReturnsToday() {
        let date = dateFromString("2015-01-20 00:00:01")
        let date2 = dateFromString("2015-01-20 10:00:00")
        
        let res = date.relativeTimeFrom(date2)
        
        XCTAssert(res == "Today")
    }
    
    func test1159pmYesterdayReturnsYesterday() {
        let date = dateFromString("2015-01-19 11:59:59")
        let date2 = dateFromString("2015-01-20 10:00:00")
        
        let res = date.relativeTimeFrom(date2)
        
        XCTAssert(res == "Yesterday")
    }
    
    func dateFromString(dateString: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-DD hh:mm:ss"
        
        return formatter.dateFromString(dateString)!
    }
    
}
