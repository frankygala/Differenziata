//
//  ViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 24/10/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit
import Foundation

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var barraTool: UIToolbar!
    
    @IBOutlet weak var testLabelMain: UILabel!
    
    var myDict: NSDictionary!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#cf2f2f")
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "ffffff")
        
        self.view.backgroundColor = UIColor(hexString: "#ffffff")
        
        //        self.barraTool.barTintColor = UIColor(hexString: "#396625")
        //        self.barraTool.tintColor = UIColor.whiteColor()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(Common.sharedInstance.getRegistredUser())
        if(Common.sharedInstance.getRegistredUser()){
            //let device = Common.sharedInstance.getDeviceToken()
            let device = "111"
            Services.sharedInstance.showTrashOfTheDay(device, completion: { (json) in
                print("json oggiapple")
                print(json)
            })

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // funzione di test -> modificare per app finale [valutare se inserire in Common]
    func callAlert(string : String){
        
        let attributedString = NSAttributedString(string: "ATTENZIONE", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(17),
            NSForegroundColorAttributeName : UIColor.redColor()
            ])
        
        let alert = UIAlertController(title: "", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Chiudi", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
