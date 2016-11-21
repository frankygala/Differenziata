//
//  CoreDataUtilities.swift
//  La differenziata - Crevalcore
//
//  Created by Francesco Galasso on 20/11/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var appDelegate  = UIApplication.sharedApplication().delegate as!AppDelegate
var managedContext : NSManagedObjectContext!  = appDelegate.managedObjectContext
var entityLastSync : NSEntityDescription? = NSEntityDescription.entityForName("Last_Sync", inManagedObjectContext: managedContext!)
var entityIndirizzo : NSEntityDescription? = NSEntityDescription.entityForName("Indirizzo", inManagedObjectContext: managedContext!)

class CoreDataUtilities: NSObject {
    
    static let sharedInstance = CoreDataUtilities()
    
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

    func saveToDB(valueAttribute : String, entityName : String, key : String){
//        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        managedContext = appDelegate.managedObjectContext
        
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
//        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        managedContext = appDelegate.managedObjectContext
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
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
        
//        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        managedContext = appDelegate.managedObjectContext
        
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
//        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        managedContext = appDelegate.managedObjectContext
        
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
//        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        managedContext = appDelegate.managedObjectContext
        
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
}
