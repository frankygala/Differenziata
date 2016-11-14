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
let LISTA_INDIRIZZI : String = "listaindirizzi.php"
let ULTIMO_SYNC : String = "lastsync.php"

// capire se bisogna spostare per refactoring
// MARK:  JSON Enums
enum JSONError: String, ErrorType {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class Services: NSObject {
    
    static let sharedInstance = Services()
    
    
    func ultimaSincronizzazione(completion:((NSDictionary) -> ())) {
        print("Creating request")
        
        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(ULTIMO_SYNC)")!
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


    func listaIndirizzi(completion:((NSDictionary) -> ())) {
        print("Creating request")
        
        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(LISTA_INDIRIZZI)")!
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
    
    
    func registrazioneUtente(uuid: String, completion:((NSDictionary) -> ())) {
        
        var uuid = "uid="+"\(uuid)"
        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(REGISTRAZIONE_PATH)"+"\(uuid)")!
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
    
    
    
    func verificaIndirizzo(via: String, civico: String, completion:((NSDictionary) -> ())) {
        
        let urlwithPercentEscapes : String!
        urlwithPercentEscapes = via.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())
        
        var via = "via=\(urlwithPercentEscapes)"
        var civico = "civico=\(civico)"
        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(VERIFICA_INDIRIZZO_PATH)\(via)&\(civico)")!
        print("url > \(url)")
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
        var uuid = "uid=\(uuid)"
        var via = "indirizzo=\(via)"
        var civico = "civico=\(civico)"
        var carta = "carta=\(carta)"
        var plastica = "plastica=\(plastica)"
        var indiff = "indifferenziata=\(indiff)"
        var verde = "verde=\(verde)"
        
        let urlwithPercentEscapes : String!
        urlwithPercentEscapes = via.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())
        via = urlwithPercentEscapes
        
        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(UPDATE_PATH)\(uuid)&\(via)&\(civico)&\(carta)&\(plastica)&\(indiff)&\(verde)")!
        
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
    
    func showTrashOfTheDay(uuid: String, completion:((NSDictionary) -> ())) {
        
        var uuid = "uid="+"\(uuid)"
        
        let url: NSURL = NSURL(string: "\(DOMAIN_URL)\(OGGI_PATH)\(uuid)")!
        print("URL > \(url)")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        
        //request.HTTPMethod = "GET"
        
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
