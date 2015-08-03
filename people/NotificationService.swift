//
//  NotificationService.swift
//  people
//
//  Created by John Grayson on 3/08/15.
//  Copyright © 2015 John Grayson. All rights reserved.
//

import Foundation
import UIKit

class NotificationService : NSObject {
    
    func addNotification(title: String, date: NSDate, id: String) {
        let notification = UILocalNotification()
        notification.alertBody = title
        notification.alertAction = "open"
        notification.fireDate = date
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["UUID": id ]
        notification.category = "REMINDER"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func cancelNotification(id: String) {
        if UIApplication.sharedApplication().scheduledLocalNotifications != nil {
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
                if (notification.userInfo!["UUID"] as! String == id) {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                    break
                }
            }
        }
    }
    
    func updateNotification(title: String, date: NSDate, id: String) {
        cancelNotification(id)
        addNotification(title, date: date, id: id)
    }
}