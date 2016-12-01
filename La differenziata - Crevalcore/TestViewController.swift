//
//  ImpostazioniViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 10/11/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class TestViewController: UIViewController  , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var backgroundColoredViews: [UIView]!
    @IBOutlet weak var textFieldIndirizzo: UITextField!
    @IBOutlet weak var textFieldCivico: UITextField!
    @IBOutlet weak var autocompleteTableView: UITableView!
    @IBOutlet weak var switchIndiff: UISwitch!
    @IBOutlet weak var switchCarta: UISwitch!
    @IBOutlet weak var switchVerde: UISwitch!
    @IBOutlet weak var switchPlastica: UISwitch!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var registrazioneView: UIView!
    @IBOutlet weak var registratoView: UIView!
    @IBOutlet weak var addressLblRegistred: UILabel!
    @IBOutlet weak var numberLblRegistred: UILabel!
    @IBOutlet weak var zoneLblRegistred: UILabel!
    @IBOutlet weak var geolocationBtn: UIButton!
    @IBOutlet weak var navBarBtn: UIBarButtonItem!
    @IBOutlet weak var indirizziView: UIView!
    @IBOutlet weak var notificheView: UIView!
    
    var autocompleteAddress = [String]()
    var appDelegate : AppDelegate?
    var managedContext : NSManagedObjectContext?
    var entityIndirizzo : NSEntityDescription?
    var array = [NSManagedObject]()
    var date_last_sync : String! = ""
    var locationManager: CLLocationManager!
    var infoAddress = [String]()
    var choiceCarta: String = ""
    var choicePlastica : String = ""
    var choiceIndifferenziata : String = ""
    var choiceVerde : String = ""
    var flag1 : Bool = false
    var flag2 : Bool = false
    var location : CLLocation!
    var indirizzoDown : String!
    var civicoDown : String!
    var zonaDown : String!
    var cartaDown : String!
    var indiffDown : String!
    var plastDown : String!
    var verdeDown : String!
    var indirizzoModify : String!
    var civicoModify : String!
    
    let device = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#DD6719")
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "ffffff")
        self.view.backgroundColor = UIColor(hexString: "#ffffff")
        
        if (Common.sharedInstance.connectedToNetwork()){
            indirizziView.alpha = 1
            notificheView.alpha = 1
            if (Common.sharedInstance.getRegistredAddress()){ //mi sono registrato precedentemente
                self.loadUI("registrato")
                SwiftLoading().showLoading()
                Services.sharedInstance.richiediImpostazioni(device) { (json) in
                    NSLog("richiedi impostazioni WillAppear")
                    
                    self.navBarBtn.title = "Modifica"
                    self.navBarBtn.enabled = true
                    Common.sharedInstance.setModificationInProgress(false)
                    
                    var indirizzo = json.objectForKey("indirizzo") as! String
                    var civico = json.objectForKey("civico") as! String
                    print("@@@@@@@@@")
                    print("civico scaricato \(civico)")
                    print("@@@@@@@@@")
                    
                    var zona = json.objectForKey("zona") as! String
                    var pushVerde = json.objectForKey("verde") as! String
                    var pushIndifferenziata = json.objectForKey("indifferenziata") as! String
                    var pushPlastica = json.objectForKey("plastica") as! String
                    var pushCarta = json.objectForKey("carta") as! String
                    
                    
                    //salvo gli indirizzi che ho salvato nel server
                    self.indirizzoDown = indirizzo
                    self.civicoDown = civico
                    self.zonaDown = zona
                    self.cartaDown = pushCarta
                    self.indiffDown = pushIndifferenziata
                    self.plastDown = pushPlastica
                    self.verdeDown = pushVerde
                    
                    //salvo la scelta della carta scaricata
                    //Common.sharedInstance.setNotificationCarta(pushCarta)
                    SwiftLoading().hideLoading()

                    
                    //aggiorno i dati visualizzati con i dati scaricati da internet
                    dispatch_async(dispatch_get_main_queue()) {
                        self.choiceVerde = self.verdeDown
                        self.choiceIndifferenziata = self.indiffDown
                        self.choicePlastica = self.plastDown
                        self.choiceCarta = self.cartaDown
                        self.addressLblRegistred.text = indirizzo
                        self.numberLblRegistred.text = civico
                        self.zoneLblRegistred.text = zona
                        self.switchIndiff.setOn(self.convertToSwitch(pushIndifferenziata), animated: false)
                        self.switchCarta.setOn(self.convertToSwitch(pushCarta), animated: false)
                        self.switchVerde.setOn(self.convertToSwitch(pushVerde), animated: false)
                        self.switchPlastica.setOn(self.convertToSwitch(pushPlastica), animated: false)
                    }
                    NSLog("scelta verde > \(self.choiceVerde)")
                    NSLog("scelta indiff > \(self.choiceIndifferenziata)")
                    NSLog("scelta plastica > \(self.choicePlastica)")
                    NSLog("scelta carta > \(self.choiceCarta)")
//                    SwiftLoading().hideLoading()
                    
                }
            } else { // mi devo registrare
                // devo impostare per la prima registrazione
                self.registratoView.alpha = 0
                self.registrazioneView.alpha = 1
                self.loadUI("registrare")
                
                self.indirizzoDown = "1"
                self.civicoDown = "1"
                self.zonaDown = "1"
                self.cartaDown = "1"
                self.indiffDown = "1"
                self.plastDown = "1"
                self.verdeDown = "1"
                
                load()
            }
            
        }else {
            indirizziView.alpha = 0
            notificheView.alpha = 0
            print("non connesso HomeView")
            callAlertConn("Connessione assente!")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
        managedContext = appDelegate!.managedObjectContext
        entityIndirizzo = NSEntityDescription.entityForName("Indirizzo", inManagedObjectContext: managedContext!)
        
        textFieldIndirizzo.delegate = self
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
        
        autocompleteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.registrazioneView.addSubview(autocompleteTableView)
        
        textFieldIndirizzo.autocorrectionType = UITextAutocorrectionType.No
        textFieldCivico.autocorrectionType = UITextAutocorrectionType.No
        
        
        // Clear background colors from labels and buttons
        for view in backgroundColoredViews {
            view.backgroundColor = UIColor.clearColor()
        }
        
        textFieldIndirizzo.addTarget(self, action: #selector(TestViewController.textFieldNumberDidChange(_:)), forControlEvents: UIControlEvents.AllEditingEvents)
        textFieldCivico.addTarget(self, action: #selector(TestViewController.textFieldAddressDidChange(_:)), forControlEvents: UIControlEvents.AllEditingEvents)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    // MARK: - TextField
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        autocompleteTableView.hidden = false
        var substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string) as NSString
        
        searchAutocompleteEntries(substring as String)
        return true      // not sure about this - could be false
    }
    
    
    func searchAutocompleteEntries(toSearch: String) {
        
        autocompleteAddress.removeAll(keepCapacity: false)
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate!.managedObjectContext
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Indirizzo")
        
        
        //var toSearch : String = self.textFieldIndirizzo.text!
        // Add Predicate
        let predicate = NSPredicate(format: "indirizzo CONTAINS[c] %@", toSearch)
        fetchRequest.predicate = predicate
        
        do {
            let records = try managedContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            if(records.isEmpty){
                autocompleteAddress.removeAll(keepCapacity: false)
                autocompleteTableView.hidden = true
            } else {
                for record in records {
                    var curString = record.valueForKey("indirizzo")!
                    autocompleteAddress.append(curString as! String)
                }
                autocompleteTableView.reloadData()
                //
            }
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteAddress.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let autoCompleteRowIdentifier = "cell"
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(autoCompleteRowIdentifier, forIndexPath: indexPath) as UITableViewCell
        let index = indexPath.row as Int
        
        cell.textLabel!.text = autocompleteAddress[index]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        print(selectedCell.textLabel?.text)
        textFieldIndirizzo.text = self.autocompleteAddress[indexPath.row]
        
        // su tap della cella nascondo keyboard e scroll view
        view.endEditing(true)
        self.autocompleteTableView.hidden = true
        flag1 = true
    }
    
    
    
    
    
    // MARK: - Remove Keyboard & hide TableView
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // tap everywhere on view to dismiss keyboard & tableView
        self.view.endEditing(true)
        self.autocompleteTableView.hidden = true
    }
    
    
    
    
    
    
    // MARK: - UI
    
    func loadUI(scelta: String){
        
        switch scelta {
        case "registrato":
            self.registrazioneView.alpha = 0
            self.registratoView.alpha = 1
            self.navBarBtn.title = "Modifica"
            self.navBarBtn.enabled = true
            
        case "registrare":
            registrazioneView.alpha = 1
            registratoView.alpha = 0
            //saveNavBtn.enabled = true
            self.navBarBtn.title = "Modifica"
            self.navBarBtn.enabled = false
            
//            self.addressLblRegistred.text = ""
//            self.numberLblRegistred.text = ""
            
        default:
            break
        }
        
    }
    
    func load() {
        // inizialmente tutti i UISwitch non sono selezionati
        switchIndiff.setOn(true, animated: false)
        switchCarta.setOn(true, animated: false)
        switchVerde.setOn(true, animated: false)
        switchPlastica.setOn(true, animated: false)
        choiceCarta = "1"
        choiceIndifferenziata = "1"
        choiceVerde = "1"
        choicePlastica = "1"
        
        addressLblRegistred.text = ""
        numberLblRegistred.text = ""
        zoneLblRegistred.text = ""
        
        verifyBtn.enabled = false
        navBarBtn.enabled = false
        
        textFieldIndirizzo.text = ""
        textFieldCivico.text = ""
        
        geolocationBtn.setImage(UIImage(named: "gps")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        geolocationBtn.alpha = 1
    }
    
    
    
    
    
    // MARK: - Geolocation
    
    func initLocationManager() {
        
        if (CLLocationManager.locationServicesEnabled())
        {
            print("sono dentro locationServicesEnabled()")
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkCoreLocationPermission()
        }
        else{
            print("Location service disabled");
        }
    }

    func checkCoreLocationPermission(){
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            SwiftLoading().showLoading()
            locationManager.startUpdatingLocation()
        } else if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == .Denied {
            locationManager.stopUpdatingLocation()
            SwiftLoading().hideLoading()
            self.geolocationBtn.enabled = true
            NSLog("dovrei richiamare un alert!!")
            callAlertGps()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        print("STAMPO LE LOCATIONS")
        print(locations)
        print(locations.count)
        location = locations.last! as CLLocation
        
        // Add below code to get address for touch coordinates.
        
        let geoCoder = CLGeocoder()
        
        let loc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
//        if(location.horizontalAccuracy <= 10){
//            locationManager.stopUpdatingLocation()
//            locationManager.delegate = nil
//        }
        print(loc)

        if(loc.horizontalAccuracy <= 20){
            geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                
                
                // Nome via
                if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                    //self.infoAddress.append(street as String)
                    self.textFieldIndirizzo.text = street as String
                    print(street)
                }
                
                // Civico
                if let buildingNumber = placeMark.addressDictionary!["SubThoroughfare"] as? NSString {
                    //self.infoAddress.append(buildingNumber as String)
                    self.textFieldCivico.text = buildingNumber as String
                    print(buildingNumber)
                }
                
                self.geolocationBtn.enabled = true
                self.verifyBtn.enabled = true
                SwiftLoading().hideLoading()
                
                
            })
            
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
        
//                locationManager.stopUpdatingLocation()
//                locationManager.delegate = nil
        
    }
    
    
    
    // MARK: - Misc
    
    func checkForSave2() {
        
        if((self.indirizzoDown == self.addressLblRegistred.text! ) && (self.civicoDown == self.numberLblRegistred.text!)){
            print("sono gli stessi")
            
            //            print("carta from server > \(self.cartaDown)")
            //            print("carta from app > \(self.choiceCarta)")
            //            print("plastica from server > \(self.plastDown)")
            //            print("plastica from app > \(self.choicePlastica)")
            //            print("indiff from server > \(self.indiffDown)")
            //            print("indiff from app > \(self.choiceIndifferenziata)")
            //            print("verde from server > \(self.verdeDown)")
            //            print("verde from app > \(self.choiceVerde)")
            if(self.cartaDown == self.choiceCarta) && (self.plastDown == self.choicePlastica) && (self.indiffDown == self.choiceIndifferenziata) && (self.verdeDown == self.choiceVerde){
                print("                                         non ho apportato modifiche")
                navBarBtn.title = "Modifica"
                Common.sharedInstance.setIsModified(false)
                var b = Common.sharedInstance.getIsModified()
                print(b)
                
                Common.sharedInstance.setNotificationCarta(self.cartaDown)
                Common.sharedInstance.setNotificationVerde(self.verdeDown)
                Common.sharedInstance.setNotificationIndiff(self.indiffDown)
                Common.sharedInstance.setNotificationPlastica(self.plastDown)
                
            } else {
                print("                                             ho apportato modifiche")
                //navBarBtn.title = "Salva"
                Common.sharedInstance.setIsModified(true)
                var b = Common.sharedInstance.getIsModified()
                print(b)
                Common.sharedInstance.setAddress(self.indirizzoDown)
                Common.sharedInstance.setNumber(self.civicoDown)
                Common.sharedInstance.setNotificationCarta(self.choiceCarta)
                Common.sharedInstance.setNotificationVerde(self.choiceVerde)
                Common.sharedInstance.setNotificationIndiff(self.choiceIndifferenziata)
                Common.sharedInstance.setNotificationPlastica(self.choicePlastica)
            }
        }
    }
    
    func textFieldNumberDidChange(textField: UITextField) {
        if(textField.text?.characters.count > 0 || textField.text != ""){
            self.flag2 = true
            
            if(self.flag2 && self.flag1){
                self.verifyBtn.enabled = true
            }
        }
        else {
            self.flag2 = false
            self.verifyBtn.enabled = false
            
        }
    }
    
    func textFieldAddressDidChange(textField: UITextField) {
        if(textField.text?.characters.count > 0 || textField.text != ""){
            self.flag1 = true
            
            if(self.flag2 && self.flag1){
                self.verifyBtn.enabled = true
            }
        }
        else {
            self.flag1 = false
            self.verifyBtn.enabled = false
        }
    }
    
    
    func checkCivico(civico : String) -> Bool{
        
        var b : Bool = false
        
        let characterset = NSCharacterSet(charactersInString: "0123456789")
        
        if (civico.rangeOfCharacterFromSet(characterset.invertedSet) != nil) {
            //callAlert("civico")
            b = false
        } else { // ok
            b = true
        }
        
        return b
    }
    
    func convertToSwitch(nomeNotificaPush : String) -> Bool{
        var flag : Bool
        if(nomeNotificaPush == "1") {
            flag = true
            return flag
        } else {
            flag = false
            return flag
        }
    }
    
    
    
    
    
    //MARK : - Alert
    
    func callAlertGps(){
        
        let attributedString = NSAttributedString(string: "ATTENZIONE", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(19),
            NSForegroundColorAttributeName : UIColor.redColor()
            ])
        
        let alert = UIAlertController(title: "", message: "Servizio di localizzazione disabilitato.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Chiudi", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func callAlertConn(string : String){
        
        let attributedString = NSAttributedString(string: "ATTENZIONE", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(17),
            NSForegroundColorAttributeName : UIColor.redColor()
            ])
        
        let alert = UIAlertController(title: "", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Chiudi", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func callAlertVerifyOK(){
        SwiftLoading().hideLoading()
        
        var titoloAlert = NSAttributedString()
        var msg = "Indirizzo coperto dal servizio." +
        "Vuoi salvare l'indirizzo?"
        let attributedString = NSAttributedString(string: "SUCCESSO", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(19),
            ])
        titoloAlert = attributedString
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.setValue(titoloAlert, forKey: "attributedTitle")
        
        
        alert.addAction(UIAlertAction(title: "Chiudi", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in
            
            self.verifyBtn.enabled = true
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Salva", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            SwiftLoading().showLoading()
            
            print("you have pressed the Salva button")
            Common.sharedInstance.setRegistredAddress(true)
            
            var via : String!
            var civico : String!
            
            via = self.textFieldIndirizzo.text
            civico = self.textFieldCivico.text
            
            NSLog("tasto salva var")
            NSLog(via)
            NSLog(civico)
            
            //            if(self.indirizzoModify != via){
            //                print("indirizzo modificato")
            //                via = self.indirizzoModify
            //            }
            //            if(self.civicoModify != civico){
            //                print("civico modificato")
            //                civico = self.civicoModify
            //            }
            
            
            let urlwithPercentEscapes : String!
            urlwithPercentEscapes = via.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())
            var via2 = urlwithPercentEscapes
            
            var v = "indirizzo=\(via2)"
            var c = "civico=\(civico)"
            var paper = "carta=\(self.choiceCarta)"
            var plastic = "plastica=\(self.choicePlastica)"
            var rusco = "indifferenziata=\(self.choiceIndifferenziata)"
            var green = "verde=\(self.choiceVerde)"
            
            
            // aggiorno i common
            Common.sharedInstance.setAddress(via)
            Common.sharedInstance.setNumber(civico)
            Common.sharedInstance.setNotificationCarta(self.choiceCarta)
            Common.sharedInstance.setNotificationPlastica(self.choicePlastica)
            Common.sharedInstance.setNotificationVerde(self.choiceIndifferenziata)
            Common.sharedInstance.setNotificationIndiff(self.choiceIndifferenziata)
            
            let requestURL: NSURL = NSURL(string: "http://crevalcore.ladifferenziata.it/updateapple.php?uid=\(self.device)&\(v)&\(c)&\(paper)&\(plastic)&\(rusco)&\(green)")!
            print("~~~~~~~~~~~~~~~~~ \(requestURL)")
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
                
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do{
                        print(data)
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                        print("json update")
                        print(json)
                        
                        var t = json.objectForKey("salvato") as! String
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            if(t == "0"){
                                SwiftLoading().hideLoading()
                                NSLog("ERRORE")
                            } else {
                                SwiftLoading().hideLoading()
                                Common.sharedInstance.setFirstTime(false)
                                Common.sharedInstance.setRegistredUser(true)
                                Common.sharedInstance.setRegistredAddress(true)
                                Common.sharedInstance.setModificationInProgress(false)
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    self.tabBarController?.selectedIndex = 0
                                }
                                //self.fix()
                            }
                        }
                        
                    }catch {
                        NSLog("Error with Json: \(error)")
                    }
                    
                } else{
                    print("ERRORE!!!! ERRORE!!!!! ERRRORE!!!!")
                }
                
            }
            task.resume()
            
            
            
        }))
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        self.verifyBtn.enabled = false
        //SwiftLoading().hideLoading()
    }
    
    
    func callAlertVerifyBad(){
        
        SwiftLoading().hideLoading()
        
        var titoloAlert = NSAttributedString()
        var msg = "Indirizzo non coperto dal servizio."
        let attributedString = NSAttributedString(string: "ATTENZIONE", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(19),
            NSForegroundColorAttributeName : UIColor.redColor()
            ])
        titoloAlert = attributedString
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.setValue(titoloAlert, forKey: "attributedTitle")
        
        
        alert.addAction(UIAlertAction(title: "Chiudi", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in
            
            self.verifyBtn.enabled = true
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        self.verifyBtn.enabled = false
        //SwiftLoading().hideLoading()
    }
    
    func callAlertCivico(){
        
        SwiftLoading().hideLoading()
        
        var titoloAlert = NSAttributedString()
        var msg = "Inserire solo caratteri numerici."
        let attributedString = NSAttributedString(string: "ATTENZIONE", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(19),
            NSForegroundColorAttributeName : UIColor.redColor()
            ])
        titoloAlert = attributedString
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.setValue(titoloAlert, forKey: "attributedTitle")
        
        
        alert.addAction(UIAlertAction(title: "Chiudi", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in
            
            self.verifyBtn.enabled = true
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        self.verifyBtn.enabled = false
    }
    
    
    
    
    
    // MARK: - Actions
    
    
    @IBAction func actionNavBarBtn(sender: UIBarButtonItem) {
        self.loadUI("registrare")
        Common.sharedInstance.setModificationInProgress(true)
    }
    
    @IBAction func actionVerificaIndirizzo(sender: UIButton) {
        
        //chetto dismiss keyboard
        dispatch_async(dispatch_get_main_queue()) {
            self.view.endEditing(true)
        }
        indirizzoModify  = self.textFieldIndirizzo.text!
        civicoModify = self.textFieldCivico.text!
        SwiftLoading().showLoading()
        
        if(checkCivico(civicoModify)){
            Services.sharedInstance.verificaIndirizzo(indirizzoModify, civico: civicoModify) { (json) in
                
                print("stampo json verificaIndirizzo")
                print(json)
                
                var reply = json.objectForKey("verificato") as! String
                self.view.endEditing(true)
                
                if(reply == "1"){
                    // la via esiste
                    self.callAlertVerifyOK()
                    
                } else {
                    self.callAlertVerifyBad()
                }
            }
        } else {
            callAlertCivico()
        }
    }
    
    
    @IBAction func actionGeo(sender: UIButton) {
        
        infoAddress.removeAll()
        textFieldCivico.text = ""
        textFieldIndirizzo.text = ""
        geolocationBtn.enabled = false
        verifyBtn.enabled = false
        location = nil
        initLocationManager()
    }
    
    @IBAction func actionCarta(sender: UISwitch) {
        
        var CartaDownloaded = Common.sharedInstance.getNotificationCarta()
        NSLog(CartaDownloaded)
        guard switchCarta.on else {
            // sono settato su OFF
            choiceCarta = "0"
            checkForSave2()
            print("disabilito notifica Carta > \(choiceCarta)")
            return
        }
        
        choiceCarta = "1"
        checkForSave2()
        print("abilito notifica Carta > \(choiceCarta)")
        
    }
    
    @IBAction func actionPlastica(sender: UISwitch) {
        guard switchPlastica.on else {
            choicePlastica = "0"
            checkForSave2()
            print("disabilito notifica Plastica > \(choicePlastica)")
            return
        }
        choicePlastica = "1"
        checkForSave2()
        print("abilito notifica Plastica > \(choicePlastica)")
    }
    
    @IBAction func actionIndiff(sender: UISwitch) {
        guard switchIndiff.on else {
            choiceIndifferenziata = "0"
            checkForSave2()
            print("disabilito notifica Indifferenziata > \(choiceIndifferenziata)")
            return
        }
        choiceIndifferenziata = "1"
        checkForSave2()
        print("disabilito notifica Indifferenziata > \(choiceIndifferenziata)")
        
    }
    
    @IBAction func actionVerde(sender: UISwitch) {
        guard switchVerde.on else {
            choiceVerde = "0"
            checkForSave2()
            print("disabilito notifica Verde > \(switchVerde)")
            return
        }
        choiceVerde = "1"
        checkForSave2()
        print("abilito notifica Verde > \(switchVerde)")
    }
    
}
