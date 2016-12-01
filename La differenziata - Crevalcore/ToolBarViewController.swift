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

extension ToolBarViewController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if let navigationController = selectedViewController as? UINavigationController, _ = navigationController.visibleViewController as? TestViewController {
            // save a reference to the viewcontroller the user wants to switch to
            viewControllerToSelect = viewController
            
            // present the alert
            if(Common.sharedInstance.getModificationInProgress()){
                showLeavingAlert()
                // return false so that the tabs do not get switched immediately
                return false
            }
        }
        
        return true
    }
}

class ToolBarViewController: UITabBarController {

    let device = UIDevice.currentDevice().identifierForVendor!.UUIDString
    var viewControllerToSelect: UIViewController?
    
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
        
        self.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLeavingAlert() {
        let leavingAlert = UIAlertController(title: "ATTENZIONE", message: "Stai per lasciare la pagina corrente.\nVuoi continuare con la modifica dell'indirizzo? ", preferredStyle: .Alert)
        
        let continueAction = UIAlertAction(title: "Si", style: .Default) { (action) in
            Common.sharedInstance.setModificationInProgress(true)
        }
        leavingAlert.addAction(continueAction)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
            // switch viewcontroller immediately
            self.performSwitch()
            Common.sharedInstance.setModificationInProgress(false)
        }
        leavingAlert.addAction(cancelAction)
        
        presentViewController(leavingAlert, animated: true, completion: nil)
    }
    
    func performSwitch() {
        if let viewControllerToSelect = viewControllerToSelect {
            // switch viewcontroller immediately
            selectedViewController = viewControllerToSelect
            // reset reference
            self.viewControllerToSelect = nil
        }
    }
    
}
