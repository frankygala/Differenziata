//
//  DettagliPattumeViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 28/10/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit

class GuidaRifiutiViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#cf2f2f")
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "ffffff")
        
        self.view.backgroundColor = UIColor(hexString: "#ffffff")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let webview = UIWebView()
        //webview.frame = self.view.bounds
        //self.view.addSubview(webview)
        
        if let fileURL = NSBundle.mainBundle().pathForResource("CALENDARIO_GEOVEST2016_CREVALCORE_WEB", ofType: "pdf") { // Use if let to unwrap to fileURL variable if file exists
            let theFileURL = NSURL(fileURLWithPath: fileURL)
            print(theFileURL)
            webView.loadRequest(NSURLRequest(URL:theFileURL))
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    @IBAction func actionHome(sender: UIBarButtonItem) {
    //
    //        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainStoryboardID") as! MainViewController
    //        self.presentViewController(vc, animated: true, completion: nil)
    //    }
    
    @IBAction func returnHome(sender: AnyObject) {
        print("tasto home premuto")
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NavigationControllerID")
        self.presentViewController(vc!, animated: true, completion: nil)
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
