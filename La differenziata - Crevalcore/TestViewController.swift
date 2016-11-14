//
//  TestViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Francesco Galasso on 10/11/16.
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
    @IBOutlet weak var optionControllerBtn: UIBarButtonItem!
    @IBOutlet weak var geolocationBtn: UIButton!

    //var autocompleteTableView: UITableView!
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#cf2f2f")
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "ffffff")
        self.view.backgroundColor = UIColor(hexString: "#ffffff")
        
        load()
        
        if (Common.sharedInstance.getRegistredUser()){ // true
            print("sono registrato")
            self.loadUI("registrato")
            optionControllerBtn.title = "Modifica"
            //let device = Common.sharedInstance.getDeviceToken()
            let device = "111"
            SwiftLoading().showLoading()
            Services.sharedInstance.richiediImpostazioni(device) { (json) in
                print("json richiediImpostazioni")
                print(json)
                
                var indirizzo = json.objectForKey("indirizzo") as! String
                var civico = json.objectForKey("civico") as! String
                var zona = json.objectForKey("zona") as! String
                var pushVerde = json.objectForKey("verde") as! String
                var pushIndifferenzianta = json.objectForKey("indifferenziata") as! String
                var pushPlastica = json.objectForKey("plastica") as! String
                var pushCarta = json.objectForKey("carta") as! String
                
                self.addressLblRegistred.text = indirizzo
                self.numberLblRegistred.text = civico
                self.zoneLblRegistred.text = zona
                
                self.switchIndiff.setOn(self.convertToSwitch(pushIndifferenzianta), animated: false)
                self.switchCarta.setOn(self.convertToSwitch(pushCarta), animated: false)
                self.switchVerde.setOn(self.convertToSwitch(pushVerde), animated: false)
                self.switchPlastica.setOn(self.convertToSwitch(pushPlastica), animated: false)
                
                SwiftLoading().hideLoading()
            }
        } else {
            print("non sono registrato")
            // devo impostare per la prima registrazione
            self.registratoView.alpha = 0
            self.registrazioneView.alpha = 1
            self.loadUI("registrare")
            
            load()
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //autocompleteTableView = UITableView(frame: CGRectMake(self.textField.bounds.minX,self.textField.bounds.maxY,self.textField.bounds.width,self.textField.bounds.height * 4), style: UITableViewStyle.Plain)
        
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
        
//        containerRegistrato.alpha = 0
//        containerRegistrazione.alpha = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func load() {
        // inizialmente tutti i UISwitch non sono selezionati
        switchIndiff.setOn(false, animated: false)
        switchCarta.setOn(false, animated: false)
        switchVerde.setOn(false, animated: false)
        switchPlastica.setOn(false, animated: false)
        choiceCarta = "0"
        choiceIndifferenziata = "0"
        choiceVerde = "0"
        choicePlastica = "0"
        
        addressLblRegistred.text = ""
        numberLblRegistred.text = ""
        zoneLblRegistred.text = ""
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
        
        print("sto cercando > \(toSearch)")
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
        case "caricamento":
            self.registrazioneView.alpha = 0
            self.registratoView.alpha = 0
            self.optionControllerBtn.enabled = false
        case "registrato":
            self.registrazioneView.alpha = 0
            self.registratoView.alpha = 1
            self.optionControllerBtn.enabled = true
        case "registrare":
            registrazioneView.alpha = 1
            registratoView.alpha = 0
            //optionControllerBtn.enabled = true
            optionControllerBtn.title = "Salva"
            optionControllerBtn.enabled = false
            
            
            
        default:
            break
        }
        
    }
    
    
    
    // MARK: - Geolocation
    
    func initLocationManager() {
        
        if (CLLocationManager.locationServicesEnabled())
        {
            print("sono dentro locationServicesEnabled()")
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            //locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        else{
            print("Location service disabled");
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        //        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //self.map.setRegion(region, animated: true)
        
        // Add below code to get address for touch coordinates.
        
        let geoCoder = CLGeocoder()
        
        let loc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        //print(loc)
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
            
        })
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    
    
    
    // MARK: - Misc
    
    func textFieldNumberDidChange(textField: UITextField) {
        if(textField.text?.characters.count > 0 || textField.text != ""){
            print("sto scrivendo")
            self.flag2 = true
            
            if(self.flag2 && self.flag1){
                print("txtfield riempiti")
                self.verifyBtn.enabled = true
            }
        }
        else {
            print("txtfield vuoto")
            self.flag2 = false
            self.verifyBtn.enabled = false
            
        }
    }
    
    func textFieldAddressDidChange(textField: UITextField) {
        if(textField.text?.characters.count > 0 || textField.text != ""){
            print("sto scrivendo")
            self.flag1 = true
            
            if(self.flag2 && self.flag1){
                print("txtfield riempiti")
                self.verifyBtn.enabled = true
            }
        }
        else {
            print("txtfield vuoto")
            self.flag1 = false
            self.verifyBtn.enabled = false
        }
    }
    
    
    func checkCivico(civico : String){
        
        print("searchTerm > \(civico)")
        
        let characterset = NSCharacterSet(charactersInString: "0123456789")
        
        if civico.rangeOfCharacterFromSet(characterset.invertedSet) != nil {
            print("string contains special characters")
            callAlert("civico")
        } else {
            print("string OK")
        }
        
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
    
    
    func callAlert(string : String){
        
        let attributedString = NSAttributedString(string: "ATTENZIONE", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(17),
            NSForegroundColorAttributeName : UIColor.redColor()
            ])
        
        var msg=""
        
        switch string {
        case "civico":
            print("problema civico")
            msg = "Devi inserire solamente caratteri numerici."
        case "indirizzo":
            print("problema indirizzo")
            msg = "Indirizzo non esistente."
            
        default:
            break
        }
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Chiudi", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Actions
    
    @IBAction func actionModifyOrSave(sender: UIBarButtonItem) {
        
        
        if(self.optionControllerBtn.title == "Modifica") {
            print("modifica dati indirizzo")
            self.loadUI("registrare")
        } else {
            // servizio update & torno alla Home
            var uuid = Common.sharedInstance.getDeviceToken()
            var via = textFieldIndirizzo.text
            var civico = textFieldCivico.text
            Services.sharedInstance.updateInformazioni(uuid, via: via!, civico: civico!, carta: choiceCarta, plastica: choicePlastica , indiff: choiceIndifferenziata, verde: choiceVerde) { (json) in
                print("json updateInformazioni")
                print(json)
            }
            self.optionControllerBtn.title = "Modifica"
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    
    @IBAction func actionVerifyBtn(sender: UIButton) {
        
        var indirizzo : String = self.textFieldIndirizzo.text!
        var numero : String = self.textFieldCivico.text!
        
        checkCivico(numero)
        
        // TOOO - chiamata server
        
        Services.sharedInstance.verificaIndirizzo(indirizzo, civico: numero) { (json) in
            print("stampo json verificaIndirizzo")
            print(json)
            
            var reply = json.objectForKey("verificato") as! String
            
            if(reply == "1"){
                // la via esiste
                self.optionControllerBtn.enabled = true
            } else {
                // la via non esiste
                self.optionControllerBtn.enabled = false
                self.callAlert("indirizzo")
            }
        }
    }
    
    
    @IBAction func actionGeolocation(sender: UIButton) {
        
        textFieldCivico.text = ""
        textFieldIndirizzo.text = ""
        geolocationBtn.enabled = false
        verifyBtn.enabled = false
        infoAddress.removeAll()
        initLocationManager()
    }
    
    @IBAction func actionCarta(sender: UISwitch) {
        guard switchCarta.on else {
            choiceCarta = "0"
            print("disabilito notifica Carta > \(choiceCarta)")
            return
        }
        choiceCarta = "1"
        print("abilito notifica Carta > \(choiceCarta)")
        
    }
    
    @IBAction func actionPlastica(sender: UISwitch) {
        guard switchPlastica.on else {
            choicePlastica = "0"
            print("disabilito notifica Plastica > \(choicePlastica)")
            return
        }
        choicePlastica = "1"
        print("abilito notifica Plastica > \(choicePlastica)")
    }
    
    @IBAction func actionIndiff(sender: UISwitch) {
        guard switchIndiff.on else {
            choiceIndifferenziata = "0"
            print("disabilito notifica Indifferenziata > \(choiceIndifferenziata)")
            return
        }
        choiceIndifferenziata = "1"
        print("disabilito notifica Indifferenziata > \(choiceIndifferenziata)")
        
    }
    
    @IBAction func actionVerde(sender: UISwitch) {
        guard switchVerde.on else {
            choiceVerde = "0"
            print("disabilito notifica Verde > \(switchVerde)")
            return
        }
        choiceVerde = "1"
        print("abilito notifica Verde > \(switchVerde)")
    }
 
}
