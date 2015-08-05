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
    
    func addNotification(title: String, body: String, date: NSDate, id: String) {
        let notification = UILocalNotification()
        notification.alertBody = title + ": " + body
        //notification.alertTitle = title
        notification.alertAction = "view"
        notification.fireDate = date
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["UUID": id ]
        notification.category = "REMINDER"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func cancelNotification(id: String) {
        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications
        
        if notifications != nil {
            for notification in notifications! as [UILocalNotification] {
                if (notification.userInfo!["UUID"] as! String == id) {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                    break
                }
            }
        }
    }
}