//
//  DataObj.swift
//  La differenziata - Crevalcore
//
//  Created by Francesco Galasso on 15/11/16.
//  Copyright © 2016 Softweb. All rights reserved.
//

import Foundation

public class DataObj {

    var materiale: String!
    var data: String!

    
    internal init(materiale : String, data : String){        
        self .materiale = materiale
        self.data = data
    }
    
    func getData() -> String {
    return self.data
    }
    
    func getMat() -> String {
        return self.materiale
    }
}
