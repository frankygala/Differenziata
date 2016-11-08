//
//  Services.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 02/11/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

let DOMAIN_URL : String = "http://crevalcore.ladifferenziata.it/"
let REGISTRAZIONE_PATH : String = "registrazioneapple.php?"
let VERIFICA_INDIRIZZO_PATH : String = "verificaindirizzo.php?"
let UPDATE_PATH : String = "updateapple.php?"
let OGGI_PATH : String = "oggiapple.php?"
let IMPOSTAZIONI_PATH : String = "setupapple.php?"

// capire se bisogna spostare per refactoring
// MARK:  JSON Enums
enum JSONError: String, ErrorType {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class Services: NSObject {
    
    static let sharedInstance = Services()
    
    //http://stackoverflow.com/questions/24647406/how-to-use-completionhandler-closure-with-return-in-swif
    
    func registrazioneUtente(uuid: String, completion:((NSDictionary) -> ())) {
        print("Creating request")
        
        var uuid = "uid="+"\(uuid)"
        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(REGISTRAZIONE_PATH)"+"\(uuid)")!
        print("URL > \(url)")
        let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
        print("Creating session registrazioneUtente")
        let session = NSURLSession.sharedSession()
        print("Send request")
        let task = session.dataTaskWithRequest(urlRequest) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            print("Checking error and nil data")
            if (error == nil && data != nil) {
                print("Request json dictionary from nsdata")
                if let result = self.NSDataToJson(data!) {
                    print("Dispatching to main queue")
                    dispatch_async(dispatch_get_main_queue()) {
                        print("Calling callback")
                        completion(result)
                    }
                }
            } else {
                print(error!.description)
            }
        }
        task.resume() //you need to call this
    }
    
    
    
    func verificaIndirizzo(via: String, civico: String, completion:((NSDictionary) -> ())) {
        
        let trimmedStringVia = via.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        var via = "via=\(trimmedStringVia)"
        print(via)
        var civico = "civico=\(civico)"
        print(civico)
        print("\(DOMAIN_URL)\(VERIFICA_INDIRIZZO_PATH)\(via)&\(civico)")
        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(VERIFICA_INDIRIZZO_PATH)\(via)&\(civico)")!
        print("url > \(url)")
        let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
        print("Creating session verificaIndirizzo")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if (error == nil && data != nil) {
                if let result = self.NSDataToJson(data!) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(result)
                    }
                }
            } else {
                print(error!.description)
            }
        }
        task.resume()
    }
    
    func richiediImpostazioni(uuid: String, completion:((NSDictionary) -> ())) {        
        var uuid = "uid="+"\(uuid)"
        //var uuid = "uid=111"
        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(IMPOSTAZIONI_PATH)\(uuid)")!
        print("URL > \(url)")
        let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if (error == nil && data != nil) {
                if let result = self.NSDataToJson(data!) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(result)
                    }
                }
            } else {
                print(error!.description)
            }
        }
        task.resume() //you need to call this
    }
    
    func updateInformazioni(uuid : String, via : String, civico : String, carta : String, plastica : String, indiff : String, verde : String, completion:((NSDictionary) -> ())) {
        var uuid = "uid="+"\(uuid)"
        
        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(IMPOSTAZIONI_PATH)\(uuid)")!
        
        let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
        print("Creating session updateInformazioni")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if (error == nil && data != nil) {
                if let result = self.NSDataToJson(data!) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(result)
                    }
                }
            } else {
                print(error!.description)
            }
        }
        task.resume()
    }
    
    func showTrashOfTheDay(uuid: String, completion:((NSDictionary) -> ())) {
        
        var uuid = "uid="+"\(uuid)"
        
        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(OGGI_PATH)\(uuid)")!
        print("URL > \(url)")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        
        request.HTTPMethod = "GET"
        
        let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
        print("Creating session updateInformazioni")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if (error == nil && data != nil) {
                if let result = self.NSDataToJson(data!) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(result)
                    }
                }
            } else {
                print(error!.description)
            }
        }
        task.resume()

        
    }
    
    //    func verificaIndirizzoOLD(via : String, civico : Int) {
    //
    //        var via = "via+\(via)"
    //        var civico = "civico+\(civico)"
    //
    //        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(VERIFICA_INDIRIZZO_PATH)"+"\(via)"+"&"+"\(civico)")!
    //        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
    //
    //        request.HTTPMethod = "GET"
    //
    //        NSURLSession.sharedSession().dataTaskWithRequest(request) {
    //            data, response, error in do {
    //
    //                guard let dat = data else { throw JSONError.NoData }
    //                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
    //
    //                if(error == nil) {
    //                    // SUCCESS
    //
    //                    print("dati ricevuti con successo")
    //
    //                    // TODO - devo controllare la risposta
    //
    //                    // FAIL
    //                    print("errore")
    //                }
    //
    //            } catch let error as JSONError {
    //                print(error.rawValue)
    //            } catch {
    //                print(error)
    //            }
    //
    //            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    //            }.resume()
    //
    //    }
    //
    //    func UpdateInformazioniOLD(uuid : String, via : String, civico : String, opzioni : [Int]) {
    //
    //        var uid = "uid+\(uuid)"
    //        var via = "via+\(via)"
    //        var civico = "civico+\(civico)"
    //
    //        let url: NSURL = NSURL(string: "\(UPDATE_PATH)+\(uid)+&+\(via)+&+\(civico)")!
    //        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
    //
    //        request.HTTPMethod = "GET"
    //
    //        NSURLSession.sharedSession().dataTaskWithRequest(request) {
    //            data, response, error in do {
    //
    //                guard let dat = data else { throw JSONError.NoData }
    //                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options: []) as? NSDictionary else { throw JSONError.ConversionFailed }
    //
    //                if(error == nil) {
    //                    // SUCCESS
    //
    //                    print("dati ricevuti con successo")
    //
    //                    // TODO - devo controllare la risposta
    //
    //                    // FAIL
    //                    print("errore")
    //                }
    //
    //            } catch let error as JSONError {
    //                print(error.rawValue)
    //            } catch {
    //                print(error)
    //            }
    //
    //            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    //            }.resume()
    //
    //    }
    
    private func NSDataToJson(data:NSData) -> NSDictionary? {
        do {
            let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            let result = json as? NSDictionary
            return result
        } catch {
            return nil
        }
    }
}
