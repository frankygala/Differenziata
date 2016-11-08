//
//  ViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 04/11/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit

class ToolBarViewController: UITabBarController {
    
    override func viewWillAppear(animated: Bool) {
        print(Common.sharedInstance.getDeviceToken())
        
        //        var device = UIDevice.currentDevice().identifierForVendor!.UUIDString
        //        print("device UUID : \(device)")
        
        var device = Common.sharedInstance.getDeviceToken()
        
        if (device == ""){
            Common.sharedInstance.saveDeviceToken()
            device = Common.sharedInstance.getDeviceToken()
        }
        
        
        print("~~~~~~~~~~")
        print(Common.sharedInstance.connectedToNetwork())
        guard Common.sharedInstance.connectedToNetwork() else {
            print("non connesso")
            Common.sharedInstance.callAlert("Connessione assente!")
            return
        }
        print("connesso")
        // chiamata server per la registrazione
        device = "111"
        Services.sharedInstance.registrazioneUtente(device) { (json) in
            print("stampo json registrazioneUtente")
            print(json)
            
            print(json.objectForKey("errore"))
            print(json.objectForKey("valore"))
            
            var error = json.objectForKey("errore") as! String
            var value = json.objectForKey("valore") as! String
            
            //value = "0" // utente non registrato
            
            /* controllo se l'utente si sia registrato con la via
             caso affermativo -> richiamo ImpostazioniVC
             caso negativo -> continuo a rimanere nella MainVC */
            if (error != "1"){
                print("no errore")
                guard value == "0" else {
                    print("Utente registrato")
                    Common.sharedInstance.setRegistredUser(true)
                    print("utente registrato > \(Common.sharedInstance.getRegistredUser())")
                    //self.selectedIndex = 3
                    
//                    let device = "111"
//                    Services.sharedInstance.showTrashOfTheDay(device, completion: { (json) in
//                        print("json oggiapple")
//                        print(json)
//                    })

                    return
                }
                print("Utente non registrato")
                Common.sharedInstance.setRegistredUser(false)
                print("utente registrato > \(Common.sharedInstance.getRegistredUser())")
                self.selectedIndex = 3
            } else {
                print("ERRORE")
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBar.barTintColor = UIColor(hexString: "#396625")
        self.tabBar.tintColor = UIColor(hexString: "#ffffff")
        
        
        print("UIID device")
//        print(Common.sharedInstance.getDeviceToken())
//        
//        //        var device = UIDevice.currentDevice().identifierForVendor!.UUIDString
//        //        print("device UUID : \(device)")
//        
//        var device = Common.sharedInstance.getDeviceToken()
//        
//        if (device == ""){
//            Common.sharedInstance.saveDeviceToken()
//            device = Common.sharedInstance.getDeviceToken()
//        }
//        
//        
//        print("~~~~~~~~~~")
//        print(Common.sharedInstance.connectedToNetwork())
//        guard Common.sharedInstance.connectedToNetwork() else {
//            print("non connesso")
//            Common.sharedInstance.callAlert("Connessione assente!")
//            return
//        }
//        print("connesso")
//        // chiamata server per la registrazione
//        Services.sharedInstance.registrazioneUtente(device) { (json) in
//            print("stampo json registrazioneUtente")
//            print(json)
//            
//            print(json.objectForKey("errore"))
//            print(json.objectForKey("valore"))
//            
//            var error = json.objectForKey("errore") as! String
//            var value = json.objectForKey("valore") as! String
//            
//            //value = "0" // utente non registrato
//            /* controllo se l'utente si sia registrato con la via
//             caso affermativo -> richiamo ImpostazioniVC
//             caso negativo -> continuo a rimanere nella MainVC */
//            if (error != "1"){
//                print("no errore")
//                guard value == "0" else {
//                    print("Utente registrato")
//                    Common.sharedInstance.setRegistredUser(true)
//                    print("utente registrato > \(Common.sharedInstance.getRegistredUser())")
//                    self.selectedIndex = 3
//                    
//                    return
//                }
//                print("Utente non registrato")
//                Common.sharedInstance.setRegistredUser(false)
//                print("utente registrato > \(Common.sharedInstance.getRegistredUser())")
//                self.selectedIndex = 3
//            } else {
//                print("ERRORE")
//            }
//        }
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
