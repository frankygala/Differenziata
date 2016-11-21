//
//  ToolBarViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 04/11/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class ToolBarViewController: UITabBarController {

    let device = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    override func viewWillAppear(animated: Bool) {
        
        NSLog("viewWillAppear")
        let tabBarItem0 = self.tabBar.items![0] as UITabBarItem
        let tabBarItem1 = self.tabBar.items![1] as UITabBarItem
        let tabBarItem2 = self.tabBar.items![2] as UITabBarItem
        let tabBarItem3 = self.tabBar.items![3] as UITabBarItem
        tabBarItem0.image = UIImage(named: "home")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem1.image = UIImage(named: "phone")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem2.image = UIImage(named: "information")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem3.image = UIImage(named: "settings")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem0.selectedImage = UIImage(named: "home_pressed")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem1.selectedImage = UIImage(named: "phone_pressed")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem2.selectedImage = UIImage(named: "information_pressed")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem3.selectedImage = UIImage(named: "settings_pressed")?.imageWithRenderingMode(.AlwaysOriginal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: .Normal)
        
        var firstTime = Common.sharedInstance.getFirstTime()
        var addressReg = Common.sharedInstance.getRegistredAddress()
        var userRegistered = Common.sharedInstance.getRegistredUser()
        
        print("@#!#@#!#@#@#")
        print("firstTime \(firstTime)")
        print("userRegistered \(userRegistered)")
        print("addressReg \(addressReg)")
        print("@#!#@#!#@#@#")
        
        if(firstTime == true && addressReg == false && userRegistered == false){
            self.selectedIndex = 3
        } else if(firstTime == false && addressReg == false && userRegistered == false){ //ritardo registrazione primo avvio
            self.selectedIndex = 3
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBar.barTintColor = UIColor(hexString: "#6CB126")
        self.tabBar.tintColor = UIColor(hexString: "#ffffff")
        
        NSLog("viewDidLoad")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 }
