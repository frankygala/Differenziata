//
//  SplashScreenViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 25/10/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit
import CoreData

class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("SplashScreen DidLoad")

        
        let triggerTime = (Int64(NSEC_PER_SEC) * 2)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                        
            let nav = self.storyboard?.instantiateViewControllerWithIdentifier("ToolBarID")
            UIApplication.sharedApplication().keyWindow?.rootViewController = nav

        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

