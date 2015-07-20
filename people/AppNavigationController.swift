//
//  AppNavigationController.swift
//  people
//
//  Created by John Grayson on 20/07/15.
//  Copyright (c) 2015 John Grayson. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationBar.barTintColor = UIColor(red: 254.0/255.0, green: 122.0/255.0, blue: 7.0/255.0, alpha: 1.0)
        self.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
