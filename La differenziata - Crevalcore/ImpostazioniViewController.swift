//
//  DetailViewController.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 24/10/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ImpostazioniViewController: UIViewController , CLLocationManagerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var txtFieldIndirizzoCasa: UITextField!
    @IBOutlet weak var txtFieldCivicoCasa: UITextField!
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFieldIndirizzoCasa.delegate = self
        txtFieldIndirizzoCasa.delegate = self
        
        self.view.backgroundColor = UIColor(hexString: "#396625")
        //loadUI("registrato")
        print("stampa getRegistredUser()")
        print(Common.sharedInstance.getRegistredUser())
        if (Common.sharedInstance.getRegistredUser()){ // true
            print("sono registrato")
            self.loadUI("registrato")
            optionControllerBtn.title = "Modifica"
            //let device = Common.sharedInstance.getDeviceToken()
            let device = "111"
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
                
            }
        } else {
            print("non sono registrato")
            // devo impostare per la prima registrazione
            self.registratoView.alpha = 0
            self.registrazioneView.alpha = 1
            self.loadUI("registrare")

            // inizialmente tutti i UISwitch non sono selezionati
            switchIndiff.setOn(false, animated: false)
            switchCarta.setOn(false, animated: false)
            switchVerde.setOn(false, animated: false)
            switchPlastica.setOn(false, animated: false)
            choiceCarta = "0"
            choiceIndifferenziata = "0"
            choiceVerde = "0"
            choicePlastica = "0"
            
            //txtFieldCivicoCasa.keyboardType = UIKeyboardType.NumberPad
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ImpostazioniViewController.checkTxtFieldTyping), name: "controllo_typing", object: nil)
            
            txtFieldIndirizzoCasa.addTarget(self, action: #selector(ImpostazioniViewController.textFieldNumberDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            txtFieldCivicoCasa.addTarget(self, action: #selector(ImpostazioniViewController.textFieldAddressDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            
            //Looks for single or multiple taps.
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImpostazioniViewController.dismissKeyboard))
            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
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
                self.txtFieldIndirizzoCasa.text = street as String
                print(street)
            }
            
            // Civico
            if let buildingNumber = placeMark.addressDictionary!["SubThoroughfare"] as? NSString {
                //self.infoAddress.append(buildingNumber as String)
                self.txtFieldCivicoCasa.text = buildingNumber as String
                print(buildingNumber)
            }
            
            self.geolocationBtn.enabled = true
            
            //self.txtFieldIndirizzoCasa.addTarget(self, action: #selector(ImpostazioniViewController.textFieldNumberDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            self.txtFieldIndirizzoCasa.addTarget(self, action: #selector(ImpostazioniViewController.textFieldNumberDidChange(_:)), forControlEvents: UIControlEvents.AllEvents)
            self.txtFieldCivicoCasa.addTarget(self, action: #selector(ImpostazioniViewController.textFieldAddressDidChange(_:)), forControlEvents: UIControlEvents.AllEvents)


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
    
//    func checkTxtFieldTyping(){
//        
//        if((self.txtFieldIndirizzoCasa.text != "") && (self.txtFieldCivicoCasa.text != "")){
//            self.verifyBtn.enabled = true
//        } else{
//            self.verifyBtn.enabled = false
//        }
//        
//        if(self.txtFieldIndirizzoCasa.text == ""){
//            print("indirizzo casa vuoto")
//        }
//        if(self.txtFieldCivicoCasa.text == ""){
//            print("civico casa vuoto")
//        }
//
//    }
    
//    func textField(txtFieldIndirizzoCasa: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        guard let text = txtFieldIndirizzoCasa.text else { return true }
//        let newLength = text.characters.count + string.characters.count - range.length
//        return newLength <= limitLength
//    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
            var via = txtFieldIndirizzoCasa.text
            var civico = txtFieldCivicoCasa.text
            Services.sharedInstance.updateInformazioni(uuid, via: via!, civico: civico!, carta: choiceCarta, plastica: choicePlastica , indiff: choiceIndifferenziata, verde: choiceVerde) { (json) in
                print("json updateInformazioni")
                print(json)
            }
            self.optionControllerBtn.title = "Modifica"
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    
    @IBAction func actionVerifyBtn(sender: UIButton) {
        
        var indirizzo : String = self.txtFieldIndirizzoCasa.text!
        var numero : String = self.txtFieldCivicoCasa.text!
        
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
        
        txtFieldCivicoCasa.text = ""
        txtFieldIndirizzoCasa.text = ""
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
