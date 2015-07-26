//
//  NSDate.swift
//  people
//
//  Created by John Grayson on 21/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import Foundation

extension NSDate {
    func calendar() -> NSCalendar{
        let cal = NSCalendar.currentCalendar()
        return cal
    }
    func yearsFrom(date:NSDate)   -> Int {
        let date1 = self
        let date2 = date
        
        calendar().rangeOfUnit(NSCalendarUnit.Year, inUnit: NSCalendarUnit.Year, forDate: self)
        calendar().rangeOfUnit(NSCalendarUnit.Year, inUnit: NSCalendarUnit.Year, forDate: date)
        
        return calendar().components(NSCalendarUnit.Year, fromDate: date2, toDate: date1, options: NSCalendarOptions(rawValue: 0)).year
    }
    func monthsFrom(date:NSDate)  -> Int {
        return calendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).month
    }
    func weeksFrom(date:NSDate)   -> Int {
        return calendar().components(NSCalendarUnit.WeekOfYear, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).weekOfYear
    }
    func daysFrom(date:NSDate)    -> Int {
        let date1 = calendar().startOfDayForDate(self)
        let date2 = calendar().startOfDayForDate(date)
        
        return calendar().components(NSCalendarUnit.Day, fromDate: date2, toDate: date1, options: NSCalendarOptions(rawValue: 0)).day
    }
    func hoursFrom(date:NSDate)   -> Int {
        return calendar().components(NSCalendarUnit.Hour, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).hour
    }
    func minutesFrom(date:NSDate) -> Int {
        return calendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).minute
    }
    func secondsFrom(date:NSDate) -> Int {
        return calendar().components(NSCalendarUnit.Second, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).second
    }
    func nanosecondsFrom(date:NSDate) -> Int {
        return calendar().components(NSCalendarUnit.Nanosecond, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).nanosecond
    }
    
    public var relativeTime: String {
        let now = NSDate()
        return relativeTimeFrom(now)
    }
    
    public func relativeTimeFrom(date: NSDate) -> String {
        //if date.
        
        if date.yearsFrom(self)   > 0 {
            if yearsFrom(self) == 1 { return "Last year" }
            return date.yearsFrom(self).description  + " year"  + { return date.yearsFrom(self)   > 1 ? "s" : "" }() + " ago"
        }
//        if date.monthsFrom(self)  > 0 {
//            return date.monthsFrom(self).description + " month" + { return date.monthsFrom(self)  > 1 ? "s" : "" }() + " ago"
//        }
        if date.weeksFrom(self) > 0 {
            //return //date.weeksFrom(self).description  + " week"  + { return date.weeksFrom(self)   > 1 ? "s" : "" }() + " ago"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EE, dd MMMM"
            
            return dateFormatter.stringFromDate(self)
        }
        
        if date.daysFrom(self) > 0 {
            if date.daysFrom(self) == 1 { return "Yesterday" }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE"
            
            return dateFormatter.stringFromDate(self)
        }
        if date.hoursFrom(self) > 0 || date.minutesFrom(self) > 0 || date.secondsFrom(self) > 0 || date.nanosecondsFrom(self) > 0 {
            return "Today"
        }
        return "N/A"
    }
}