//
//  ViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 04/11/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class ToolBarViewController: UITabBarController {
    
    var appDelegate : AppDelegate?
    var managedContext : NSManagedObjectContext?
    var entityLastSync : NSEntityDescription?
    var entityIndirizzo : NSEntityDescription?
    
    override func viewWillAppear(animated: Bool) {
        let device = UIDevice.currentDevice().identifierForVendor!.UUIDString
        var date_sync_web : String! = ""

        appDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
        managedContext = appDelegate!.managedObjectContext
        entityLastSync = NSEntityDescription.entityForName("Last_Sync", inManagedObjectContext: managedContext!)
        entityIndirizzo = NSEntityDescription.entityForName("Indirizzo", inManagedObjectContext: managedContext!)
        
        print(returnCount("Last_Sync"))
        print(returnCount("Indirizzo"))
        //        deleteAllData("Last_Sync")
        //        print(returnCount("Last_Sync"))
        //        print(returnCount("Indirizzo"))
        //        deleteAllData("Indirizzo")
        
        
        if (!Common.sharedInstance.connectedToNetwork()){
            
            print("connesso")
            print("UIID device > \(device)")
            
            Services.sharedInstance.ultimaSincronizzazione({ (reply) in
                print("ultima sincronizzazione : \(reply)")
                date_sync_web = reply.objectForKey("lastsync") as! String
                
                if(self.existsLastSync()){
                    print("esiste lastsync")
                    print("controllo se è aggiornato")
                    if(self.isUpdated(date_sync_web)){
                        print("aggiornato")
                        //self.downloadListaIndirizzi()
                    }else {
                        print("da aggiornare")
                        self.deleteAllData("Last_Sync")
                        self.saveToDB(date_sync_web, entityName: "Last_Sync", key: "last_sync") // lo ricreo
                        self.deleteAllData("Indirizzo")
                        self.downloadListaIndirizzi()
                        
                    }
                }else {
                    print("non esiste lastsync")
                    print("lo devo creare")
                    self.saveToDB(date_sync_web, entityName: "Last_Sync", key: "last_sync") // lo creo
                    self.downloadListaIndirizzi()
                }
            })
//
//            Services.sharedInstance.registrazioneUtente(device) { (json) in
//                print("stampo json registrazioneUtente")
//                print(json)
//                
//                var error = json.objectForKey("errore") as! String
//                var value = json.objectForKey("valore") as! String
//                
//                if (error != "1"){ // no errore
//                    if (value == "1"){ // user already registred
//                        
//                        print("Utente registrato")
//                        // services showTrashOfTheDay
//                        Common.sharedInstance.setRegistredUser(true)
//                        
//                    } else if (value == "2"){ // new user's registration
//                        Common.sharedInstance.setRegistredUser(false)
//                        self.selectedIndex = 3
//                    }else { // user not registred
//                        
//                    }
//                }else {
//                    print("ERRORE UID VUOTO o SBAGLIATO")
//                    }
//            }
        } else {
            print("CONNESSIONE ASSENTE")
            
            // INIZIO test simulatore
            var error = "0"
            var value = "1"
//            Services.sharedInstance.ultimaSincronizzazione({ (reply) in
//                print("ultima sincronizzazione : \(reply)")
//                date_sync_web = reply.objectForKey("lastsync") as! String
//                
//                if(self.existsLastSync()){
//                    print("esiste lastsync")
//                    print("controllo se è aggiornato")
//                    if(self.isUpdated(date_sync_web)){
//                        print("aggiornato")
//                        //self.downloadListaIndirizzi()
//                    }else {
//                        print("da aggiornare")
//                        self.deleteAllData("Last_Sync")
//                        self.saveToDB(date_sync_web, entityName: "Last_Sync", key: "last_sync") // lo ricreo
//                        self.deleteAllData("Indirizzo")
//                        self.downloadListaIndirizzi()
//                        
//                    }
//                }else {
//                    print("non esiste lastsync")
//                    print("lo devo creare")
//                    self.saveToDB(date_sync_web, entityName: "Last_Sync", key: "last_sync") // lo creo
//                    self.downloadListaIndirizzi()
//                }
//            })
            if (error != "1"){ // no errore
                if (value == "1"){ // user already registred
                    
                    print("Utente registrato")
                    // services showTrashOfTheDay
                    Common.sharedInstance.setRegistredUser(true)
                    
                } else if (value == "2"){ // new user's registration
                    Common.sharedInstance.setRegistredUser(false)
                    self.selectedIndex = 3
                }else { // user not registred
                    
                }
            }
            // FINE test simulatore

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBar.barTintColor = UIColor(hexString: "#396625")
        self.tabBar.tintColor = UIColor(hexString: "#ffffff")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Services
    
    func downloadListaIndirizzi () {
        let requestURL: NSURL = NSURL(string: "http://crevalcore.ladifferenziata.it/listaindirizzi.php")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    //print(json)
                    
                    if let listAddress = json as? [[String: AnyObject]] {
                        for address in listAddress {
                            //print(address["indirizzo"]!)
                            self.saveToDB(address["indirizzo"]! as! String, entityName: "Indirizzo", key: "indirizzo") // lo creo
                        }
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        task.resume()
        
    }
    

    
    
    // MARK: - DB Misc

    func saveToDB(valueAttribute : String, entityName : String, key : String){
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate!.managedObjectContext
        
        var entity = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext!)
        
        // add our data
        entity.setValue(valueAttribute, forKey: key)
        
        // save it
        do {
            try managedContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    func deleteAllData(entity: String)
    {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate!.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try! managedContext!.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext!.deleteObject(managedObjectData)
                
                // save it
                do {
                    try managedContext!.save()
                    print("elemento cancellato dal DB")
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    func returnCount(entity : String) -> Int {
        var count : Int?
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate!.managedObjectContext
        
        var arrayLastSync  = [AnyObject]() // Where Locations = your NSManaged Class
        
        var fetchRequest = NSFetchRequest(entityName: entity)
        arrayLastSync = try! managedContext!.executeFetchRequest(fetchRequest) as! [AnyObject]
        
        count = arrayLastSync.count
        
        return count!
    }
    
    /*
     controlla se esiste lastsync nel database
     TRUE -> esiste
     FALSE -> non esiste
     */
    func existsLastSync() -> Bool{
        
        var isEmpty = true
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate!.managedObjectContext
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Last_Sync")
        
        do {
            let records = try managedContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            isEmpty = !records.isEmpty
            print(">> \(isEmpty) <<")
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return isEmpty
        
    }
    
    /*
     controlla se lastsync è uguale a quello online
     TRUE -> aggiornato
     FALSE -> da aggiornare
     */
    func isUpdated (web_last_sync : String) -> Bool{
        var isSync = true
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate!.managedObjectContext
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Last_Sync")
        
        // Add Predicate
        let predicate = NSPredicate(format: "last_sync CONTAINS[c] %@", web_last_sync)
        fetchRequest.predicate = predicate
        
        do {
            let records = try managedContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            for record in records {
                print(record.valueForKey("last_sync")!)
            }
            //
            isSync = !records.isEmpty
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return isSync
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // http://stackoverflow.com/questions/34726703/swift-how-to-find-the-nearest-date-of-the-stored-data
    
}
