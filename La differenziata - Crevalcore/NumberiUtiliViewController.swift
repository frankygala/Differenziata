//
//  NumberiUtiliViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Francesco Galasso on 07/11/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit

class NumeriUtiliViewController: UIViewController {
    
    @IBOutlet weak var phoneBtn: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#cf2f2f")
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "ffffff")
        
        self.view.backgroundColor = UIColor(hexString: "#ffffff")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionPhoneCall(sender: UIButton) {
        callNumber((phoneBtn.titleLabel?.text)!)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: Call Number
    func callNumber(number : String) {
        
        let str = number
        let arr = str.characters.split{" \u{00A0}".characters.contains($0)}.map(String.init)
        let str3 = arr.filter { !$0.hasPrefix("+") }.joinWithSeparator("")
        let url = NSURL(string: "tel://\(str3)")
        
        if  UIApplication.sharedApplication().canOpenURL(url!) {
            dispatch_async(dispatch_get_main_queue(), {
                let message = String(format: "Sei sicuro di voler chiamare?", number)
                let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Chiama", style: UIAlertActionStyle.Default, handler: { (_) in
                    
                    UIApplication.sharedApplication().openURL(url!)
                }))
                
                alert.addAction(UIAlertAction(title: "Annulla", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    })
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            })
        } else {
            showInfoAlert("ERRORE")
        }
    }
    
    func showInfoAlert(message : String) {
        let alert = UIAlertController(title: NSLocalizedString("default_alert_title", comment: "default_alert_title"), message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //    func currentRootViewController() -> UIViewController {
    //        return UIApplication.sharedApplication().keyWindow?.rootViewController as! MainViewController
    //    }
    
}
