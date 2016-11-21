//
//  Common.swift
//  La differenziata - Crevalcore
//
//  Created by Developer on 24/10/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import UIKit
import SystemConfiguration

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


private let userDefaults = NSUserDefaults.standardUserDefaults()
private let _registredUser : String = "registredUser"
private let _deviceToken : String = "deviceToken"
private let _lastSync : String = "lastSync"
private let _registredAddress : String = "registredAddress"
private let _token : String = "token"
private let _firstTimeAccess : String = "firstTimeAccess"
private let _isModified : String = "notificationIsModified"
private let _choicePaper : String = "choicePaper"
private let _choicePlastic : String = "choicePlastic"
private let _choiceGreen : String = "choiceGreen"
private let _choiceUndifferentiated : String = "choiceUndifferentiated"
private let _address : String = "address"
private let _number : String = "number"


class Common: NSObject {
    
    static let sharedInstance = Common()
    
    
    
    //MARK: - token device
    func setToken(token : String) {
        userDefaults.setObject(token, forKey: _token)
        userDefaults.synchronize()
    }
    
    func getToken() -> String{
        return userDefaults.objectForKey(_token) as? String ?? ""
    }
    
    
    
    // MARK: - LastSync
    func setLastSync(data : String) {
        userDefaults.setObject(data, forKey: _lastSync)
        userDefaults.synchronize()
    }
    
    func getLastSync() -> String {
        return userDefaults.objectForKey(_lastSync) as? String ?? ""
    }
    
    func cleanLastSync() {
        userDefaults.removeObjectForKey(_lastSync)
        userDefaults.synchronize()
    }
    
    
    
    // MARK: - User Logged First Time
    func setFirstTime(firstTime : Bool){
        userDefaults.setObject(firstTime, forKey: _firstTimeAccess)
        userDefaults.synchronize()
    }
    
    func getFirstTime() -> Bool{
        return userDefaults.boolForKey(_firstTimeAccess)
    }
    
    
    
    // MARK: - User Registration
    func setRegistredUser(registredUser : Bool) {
        userDefaults.setBool(registredUser, forKey: _registredUser)
        userDefaults.synchronize()
    }
    
    func getRegistredUser() -> Bool {
        return userDefaults.boolForKey(_registredUser) as Bool
    }
    
    func cleanRegistredUser() {
        userDefaults.removeObjectForKey(_registredUser)
        userDefaults.synchronize()
    }
    
    
    
    // MARK: - Address Registration
    func setRegistredAddress(registredAddress : Bool) {
        userDefaults.setBool(registredAddress, forKey: _registredAddress)
        userDefaults.synchronize()
    }
    
    func getRegistredAddress() -> Bool {
        return userDefaults.boolForKey(_registredAddress) as Bool
    }
    
    func cleanRegistredAddress() {
        userDefaults.removeObjectForKey(_registredAddress)
        userDefaults.synchronize()
    }
    
    
    
    
    // MARK: - Connection
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
    
    // MARK: - Alert Message
    func callAlert(string : String){
        
        let attributedString = NSAttributedString(string: "ATTENZIONE", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(17),
            NSForegroundColorAttributeName : UIColor.redColor()
            ])
        
        let alert = UIAlertController(title: "", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Chiudi", style: UIAlertActionStyle.Default, handler: nil))
    }
    
    
    
    // MARK: - User Notification Changed by User
    func setIsModified(isModified : Bool) {
        userDefaults.setBool(isModified, forKey: _isModified)
        userDefaults.synchronize()
    }
    
    func getIsModified() -> Bool {
        return userDefaults.boolForKey(_isModified) as Bool
    }
    
    func cleanIsModified() {
        userDefaults.removeObjectForKey(_isModified)
        userDefaults.synchronize()
    }
    
    
    
    // MARK: - Notification Paper
    func setNotificationCarta(choicePaper : String) {
        userDefaults.setObject(choicePaper, forKey: _choicePaper)
        userDefaults.synchronize()
    }
    
    func getNotificationCarta() -> String {
        return userDefaults.objectForKey(_choicePaper) as? String ?? ""
    }
    
    func cleanNotificationCarta() {
        userDefaults.removeObjectForKey(_choicePaper)
        userDefaults.synchronize()
    }
    
    
    
    // MARK: - Notification Plastic
    func setNotificationPlastica(choicePlastc : String) {
        userDefaults.setObject(choicePlastc, forKey: _choicePlastic)
        userDefaults.synchronize()
    }
    
    func getNotificationPlastica() -> String {
        return userDefaults.objectForKey(_choicePlastic) as? String ?? ""
    }
    
    func cleanNotificationPlastica() {
        userDefaults.removeObjectForKey(_choicePlastic)
        userDefaults.synchronize()
    }
    
    
    
    // MARK: - Notification Green
    func setNotificationVerde(choiceGreen : String) {
        userDefaults.setObject(choiceGreen, forKey: _choiceGreen)
        userDefaults.synchronize()
    }
    
    func getNotificationVerde() -> String {
        return userDefaults.objectForKey(_choiceGreen) as? String ?? ""
    }
    
    func cleanNotificationVerde() {
        userDefaults.removeObjectForKey(_choiceGreen)
        userDefaults.synchronize()
    }
    
    
    
    // MARK: - Notification Undifferentiated
    func setNotificationIndiff(choiceUndiff : String) {
        userDefaults.setObject(choiceUndiff, forKey: _choiceUndifferentiated)
        userDefaults.synchronize()
    }
    
    func getNotificationIndiff() -> String {
        return userDefaults.objectForKey(_choiceUndifferentiated) as? String ?? ""
    }
    
    func cleanNotificationIndiff() {
        userDefaults.removeObjectForKey(_choiceUndifferentiated)
        userDefaults.synchronize()
    }
    
    
    
    // MARK: - Address
    func setAddress(address : String) {
        userDefaults.setObject(address, forKey: _address)
        userDefaults.synchronize()
    }
    
    func getAddress() -> String {
        return userDefaults.objectForKey(_address) as? String ?? ""
    }
    
    func cleanAddress() {
        userDefaults.removeObjectForKey(_address)
        userDefaults.synchronize()
    }
    
    
    
    // MARK: - Address
    func setNumber(number : String) {
        userDefaults.setObject(number, forKey: _number)
        userDefaults.synchronize()
    }
    
    func getNumber() -> String {
        return userDefaults.objectForKey(_number) as? String ?? ""
    }
    
    func cleanNumber() {
        userDefaults.removeObjectForKey(_number)
        userDefaults.synchronize()
    }
}
