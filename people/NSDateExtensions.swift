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
        return NSCalendar.currentCalendar().components(.CalendarUnitYear, fromDate: date, toDate: self, options: nil).year
    }
    func monthsFrom(date:NSDate)  -> Int {
        return NSCalendar.currentCalendar().components(.CalendarUnitMonth, fromDate: date, toDate: self, options: nil).month
    }
    func weeksFrom(date:NSDate)   -> Int {
        return NSCalendar.currentCalendar().components(.CalendarUnitWeekOfYear, fromDate: date, toDate: self, options: nil).weekOfYear
    }
    func daysFrom(date:NSDate)    -> Int {
        return NSCalendar.currentCalendar().components(.CalendarUnitDay, fromDate: date, toDate: self, options: nil).day
    }
    func hoursFrom(date:NSDate)   -> Int {
        return NSCalendar.currentCalendar().components(.CalendarUnitHour, fromDate: date, toDate: self, options: nil).hour
    }
    func minutesFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.CalendarUnitMinute, fromDate: date, toDate: self, options: nil).minute
    }
    func secondsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.CalendarUnitSecond, fromDate: date, toDate: self, options: nil).second
    }
    func nanosecondsFrom(date:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.CalendarUnitSecond, fromDate: date, toDate: self, options: nil).nanosecond
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
        
        
//        if now.hoursFrom(self)   > 0 {
//            return "\(now.hoursFrom(self)) hour"     + { return now.hoursFrom(self)   > 1 ? "s" : "" }() + " ago"
//        }
//        if now.minutesFrom(self) > 0 {
//            return "\(now.minutesFrom(self)) minute" + { return now.minutesFrom(self) > 1 ? "s" : "" }() + " ago"
//        }
//        if now.secondsFrom(self) > 0 {
//            if now.secondsFrom(self) < 15 { return "Just now"  }
//            return "\(now.secondsFrom(self)) second" + { return now.secondsFrom(self) > 1 ? "s" : "" }() + " ago"
//        }
//        return ""
    }
}