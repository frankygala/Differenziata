//
//  GuidaViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 28/10/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit

class GuidaRifiutiViewController: UIViewController {
    
    
    @IBOutlet weak var webView: UIWebView!
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
                
                Services.sharedInstance.updateInformazioni(device, via: via, civico: civico, carta: carta, plastica: plastica, indiff: indiff, verde: verde, completion: { (json) in
                    print(json)
                })
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        SwiftLoading().showLoading()
        if let fileURL = NSBundle.mainBundle().pathForResource("CALENDARIO_GEOVEST2016_CREVALCORE_WEB", ofType: "pdf") { // Use if let to unwrap to fileURL variable if file exists
            let theFileURL = NSURL(fileURLWithPath: fileURL)
            print(theFileURL)
            webView.loadRequest(NSURLRequest(URL:theFileURL))
//            SwiftLoading().hideLoading()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
