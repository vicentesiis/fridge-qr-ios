//
//  Utils.swift
//  fridge-qr
//
//  Created by Vicente Cantu Garcia on 11/20/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import Foundation

class Utils {
    
    static func dataToString(_ value: Data) -> String{
        let string = String(data: value, encoding: String.Encoding.utf8)
        return string!
    }
    
}
