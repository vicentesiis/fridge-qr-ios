//
//  Utils.swift
//  fridge-qr
//
//  Created by Vicente Cantu Garcia on 11/20/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func dataToString(_ value: Data) -> String{
        let string = String(data: value, encoding: String.Encoding.utf8)
        return string!
    }
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
