//
//  NumeriUtiliViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 08/11/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit

class NumeriUtiliViewController: UIViewController {
    
    @IBOutlet weak var callBtn: UIButton!
    
    let device = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#DD6719")
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "ffffff")
        
        self.view.backgroundColor = UIColor(hexString: "#ffffff")
        
        if(Common.sharedInstance.connectedToNetwork()){
            if(Common.sharedInstance.getIsModified() == true){
                
                var via = Common.sharedInstance.getAddress()
                var civico = Common.sharedInstance.getNumber()
                var carta = Common.sharedInstance.getNotificationCarta()
                var plastica = Common.sharedInstance.getNotificationPlastica()
                var indiff = Common.sharedInstance.getNotificationIndiff()
                var verde = Common.sharedInstance.getNotificationVerde()
                
                
                NSLog("Numeri utili civico \(civico)")
                Services.sharedInstance.updateInformazioni(device, via: via, civico: civico, carta: carta, plastica: plastica, indiff: indiff, verde: verde, completion: { (json) in
                    print(json)
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - Actions
    
    @IBAction func actionPhoneCall(sender: UIButton) {
        callNumber((callBtn.titleLabel?.text)!)
    }
    
    
    
    // MARK: - Misc
    
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

    
}
