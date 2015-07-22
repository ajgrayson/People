//
//  NSDate.swift
//  people
//
//  Created by John Grayson on 21/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import Foundation

extension NSDate {
    func yearsFrom(date:NSDate)   -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).year
    }
    func monthsFrom(date:NSDate)  -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).month
    }
    func weeksFrom(date:NSDate)   -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYear, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).weekOfYear
    }
    func daysFrom(date:NSDate)    -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).day
    }
    func hoursFrom(date:NSDate)   -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).hour
    }
    func minutesFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).minute
    }
    func secondsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).second
    }
    func nanosecondsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Nanosecond, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).nanosecond
    }
    var relativeTime: String {
        let now = NSDate()
        if now.yearsFrom(self)   > 0 {
            return now.yearsFrom(self).description  + " year"  + { return now.yearsFrom(self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.monthsFrom(self)  > 0 {
            return now.monthsFrom(self).description + " month" + { return now.monthsFrom(self)  > 1 ? "s" : "" }() + " ago"
        }
        if now.weeksFrom(self)   > 0 {
            return now.weeksFrom(self).description  + " week"  + { return now.weeksFrom(self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.daysFrom(self)    > 0 {
            if daysFrom(self) == 1 { return "Yesterday" }
            return now.daysFrom(self).description + " days ago"
        }
        if now.hoursFrom(self) > 0 || now.minutesFrom(self) > 0 || now.secondsFrom(self) > 0 || now.nanosecondsFrom(self) > 0 {
            return "Today"
        }
        return "N/A"
    }
}