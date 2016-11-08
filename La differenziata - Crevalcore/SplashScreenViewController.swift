//
//  SplashScreenViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 25/10/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // launching test
        //Common.sharedInstance.setLookedSettings(false)
        
        //test di avvio del cell
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 2)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            
            print("sono dentro il dispatch dello splashScreen")
            
            
            let nav = self.storyboard?.instantiateViewControllerWithIdentifier("ToolBarID")
            UIApplication.sharedApplication().keyWindow?.rootViewController = nav
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
