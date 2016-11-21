//
//  HomeViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 24/10/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class HomeViewController: UIViewController {
    
    let device = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    var arrayDatePattume = [String]()
    var currentDay: String!
    var arrayPattume = [String]()
    var list = [DataObj]()
    var list2 = [DataObj]()
    var sortedDates = [String]()
    
    @IBOutlet weak var containerInfoGiorno: UIView!
    @IBOutlet weak var containerInfoPattume: UIView!
    @IBOutlet var pattumeViews: [UIView]!
    @IBOutlet var pattumeLabels: [UILabel]!
    @IBOutlet var pattumeImageViews: [UIImageView]!
    @IBOutlet var backgroundColoredViews: [UIView]!
    @IBOutlet var slotViews : [UIView]!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var reminderLbl: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("Home viewWillAppear")
        
        let device = UIDevice.currentDevice().identifierForVendor!.UUIDString
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#DD6719")
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "ffffff")
        
        self.view.backgroundColor = UIColor(hexString: "#ffffff")
        
        infoLbl.alpha = 0
        reminderLbl.alpha = 0
        
        for view in pattumeViews {
            view.alpha = 0
            view.backgroundColor = UIColor.clearColor()
        }
        
        for image in pattumeImageViews {
            image.alpha = 0
        }
        
        for lbl in pattumeLabels {
            lbl.alpha = 0
            lbl.text = ""
        }
        
        arrayDatePattume.removeAll()
        
        let date = NSDate()
        let calender = NSCalendar.currentCalendar()
        let c = calender.components([.Day, .Month, .Year], fromDate: date)
        let day = c.day
        let month = c.month
        let year = c.year
        currentDay = "\(day)-\(month)-\(year)"
        print("currentDay : \(currentDay)")
        
        var firstTime = Common.sharedInstance.getFirstTime()
        var addressReg = Common.sharedInstance.getRegistredAddress()
        var userRegistered = Common.sharedInstance.getRegistredUser()
        
        if (Common.sharedInstance.connectedToNetwork()){
            
            print("firstTime \(firstTime)")
            print("userRegistered \(userRegistered)")
            print("addressReg \(addressReg)")
            
            if(Common.sharedInstance.getIsModified() == true){
                
                var via = Common.sharedInstance.getAddress()
                var civico = Common.sharedInstance.getNumber()
                var carta = Common.sharedInstance.getNotificationCarta()
                var plastica = Common.sharedInstance.getNotificationPlastica()
                var indiff = Common.sharedInstance.getNotificationIndiff()
                var verde = Common.sharedInstance.getNotificationVerde()
                
                Services.sharedInstance.updateInformazioni(device, via: via, civico: civico, carta: carta, plastica: plastica, indiff: indiff, verde: verde, completion: { (json) in
                    print(json.objectForKey("salvato"))
                })
            }
            
            
            if(firstTime == false && userRegistered == true && addressReg == true){
                containerInfoPattume.alpha = 1
                containerInfoGiorno.alpha = 1
                visualizzaImmondizia()
            } else if (firstTime == false && userRegistered == true && addressReg == false){
                containerInfoGiorno.alpha = 0
                containerInfoPattume.alpha = 0
                callAlert("Registrare l'indirizzo", type: "BAD_ADDR")
            } else if (firstTime == true && userRegistered == false && addressReg == false){
                containerInfoGiorno.alpha = 0
                containerInfoPattume.alpha = 0
                callAlert("Registrare l'indirizzo", type: "BAD_ADDR")
            }
        }
        else {
            containerInfoGiorno.alpha = 0
            containerInfoPattume.alpha = 0
            print("non connesso HomeView")
            callAlert("Connessione assente!", type: "BAD_CONN")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Clear background colors from labels and buttons
        for view in backgroundColoredViews {
            view.backgroundColor = UIColor.clearColor()
        }
        
        NSLog("HOME viewDidLoad")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - Alert
    func callAlert(string : String,type : String){
        
        let attributedString = NSAttributedString(string: "ATTENZIONE", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(17),
            NSForegroundColorAttributeName : UIColor.redColor()
            ])
        
        let alert = UIAlertController(title: "", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        if(type == "BAD_CONN" || type == "BAD_JSON"){
            alert.addAction(UIAlertAction(title: "Chiudi", style: UIAlertActionStyle.Default, handler: nil))
        }else {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in
                print("you have pressed the OK button")
                
                self.tabBarController!.selectedIndex = 3
            }))
            
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK: - Misc
    
    func visualizzaInfoPattume(numeroRusco : String) -> [String]{
        var array = [String]()
        
        switch numeroRusco {
        case "1" :
            array.append("Carta")
            array.append("1f97d0")
        case "2" :
            array.append("Indifferenziata")
            array.append("9D9D9C")
        case "3" :
            array.append("Plastica")
            array.append("fcc400")
        case "4" :
            array.append("Umido")
            array.append("a2732b")
        case "5" :
            array.append("Vetro e Lattine")
            array.append("44a12b")
        case "6" :
            array.append("Verde")
            array.append("BCCF00")
        default:
            break;
        }
        return array
    }
    
    func visualizzaImmondizia() {
        
        SwiftLoading().showLoading()
        let requestURL: NSURL = NSURL(string: "http://crevalcore.ladifferenziata.it/oggiapple.php?uid=\(device)")!
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
                    print(json)
                    
                    self.list.removeAll()
                    self.list2.removeAll()
                    self.sortedDates.removeAll()
                    
                    for i in 0..<json.count{
                        var mat : String!
                        
                        if(self.isNull(json[i]["materiale"])) {
                            mat = "3" // era per test
                        } else {
                            mat = json[i]["materiale"] as! String
                        }
                        var data = json[i]["data"] as! String
                        let obj = DataObj(materiale: mat, data: data)
                        self.list.append(obj)
                        self.arrayDatePattume.append(json[i]["data"] as! String)
                    }
                    
                    if(self.arrayDatePattume.isEmpty){
                        NSLog("JSON VUOTO")
                        SwiftLoading().hideLoading()
                        self.callAlert("Errore trasmissione dati server!", type: "BAD_JSON")
                    } else {
                        
                        print("sono dentro ELSE -> arraDatePattume vuoto")
                        self.sortedDates = self.arrayDatePattume.sort(){$0 < $1}
                        print(self.sortedDates)
                        var confronto = self.sortedDates[0]
                        let dateStringFormatter = NSDateFormatter()
                        dateStringFormatter.dateFormat = "dd-MM-yyyy"
                        dateStringFormatter.locale = NSLocale(localeIdentifier: "it")
                        dateStringFormatter.timeZone = NSTimeZone(name: "GMT+1")
                        let date = dateStringFormatter.dateFromString(confronto) //nsdate
                        print(date)
                        var formatter20 = NSDateFormatter()
                        formatter20.dateStyle = NSDateFormatterStyle.FullStyle
                        formatter20.timeStyle = .NoStyle
                        let dateString20 = formatter20.stringFromDate(date!)
                        print("dateString20 > \(dateString20)") //data di oggi FullStyle
                        
                        let pattern = "\\w+\\s?"
                        let regex  = try! NSRegularExpression(pattern: pattern, options: [])
                        let matches = regex.matchesInString(dateString20, options:[], range: NSMakeRange(0, dateString20.characters.count))
                            .map { (dateString20 as NSString).substringWithRange($0.range)}
                        print("\(matches[0]) \(matches[1])")
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.infoLbl.alpha = 1
                            self.reminderLbl.alpha = 1
                            self.infoLbl.text = "\(matches[0]) \(matches[1])"
                            
                            if(self.sortedDates[0] == self.currentDay){
                                self.reminderLbl.text = "Oggi ritirano"
                            } else {
                                self.reminderLbl.text = "Prossimo ritiro"
                                
                            }
                            
                            self.list.sortInPlace({ $0.data < $1.data })
                            
                            for k in 0..<self.list.count{
                                
                                let t = self.list[k].getData()
                                if(t == self.sortedDates[0]){
                                    var numMat = self.list[k].getMat()
                                    self.arrayPattume = self.visualizzaInfoPattume(numMat)
                                    let obj = DataObj(materiale: self.list[k].getMat(), data: self.list[k].getData())
                                    print(obj)
                                    self.list2.append(obj)
                                }
                            }
                            
                            for j in 0..<self.list2.count{
                                self.pattumeLabels[j].alpha = 1
                                self.pattumeImageViews[j].alpha = 1
                                self.pattumeViews[j].alpha = 1
                                //self.pattumeLabels[j].text = self.arrayPattume[0]
                                self.pattumeLabels[j].text = "Indifferenziata"
                                
                                self.pattumeViews[j].backgroundColor = UIColor(hexString:self.arrayPattume[1])
                                self.pattumeImageViews[j].image = UIImage(named: "trash")
                                
                            }
                            
                            SwiftLoading().hideLoading()
                        })
                        
                    }
                    
                    
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        task.resume()
        
    }
    
    func isNull(someObject: AnyObject?) -> Bool {
        guard let someObject = someObject else {
            return true
        }
        
        return (someObject is NSNull)
    }
}
