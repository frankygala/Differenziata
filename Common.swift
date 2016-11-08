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
// inutili cancellare alla fine per refactoring
private let _address : String = "address"
private let _streetNumber : String = "streetNumber"

class Common: NSObject {
    
    static let sharedInstance = Common()
    
    var regReply: [String] = []
    
    // MARK: Street User's Registred
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
    
    // MARK:  Device Token
    func saveDeviceToken() {
        let device = UIDevice.currentDevice().identifierForVendor!.UUIDString
        userDefaults.setObject(device, forKey: _deviceToken)
        userDefaults.synchronize()
    }
    
    func getDeviceToken() -> String {
        return userDefaults.objectForKey(_deviceToken) as? String ?? ""
    }
    
    // MARK: Address
    func setAddress(Address : Bool){
        userDefaults.setBool(Address, forKey: _address)
        userDefaults.synchronize()
    }
    
    func cleanAddress() {
        userDefaults.removeObjectForKey(_address)
        userDefaults.synchronize()
    }
    
    func getAddress() -> String {
        return userDefaults.objectForKey(_address) as! String
    }
    
    // MARK: Connection
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
    
    // MARK: Alert Message
    func callAlert(string : String){
        
        let attributedString = NSAttributedString(string: "ATTENZIONE", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(17),
            NSForegroundColorAttributeName : UIColor.redColor()
            ])
        
        let alert = UIAlertController(title: "", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: "Chiudi", style: UIAlertActionStyle.Default, handler: nil))
    }
    
}
