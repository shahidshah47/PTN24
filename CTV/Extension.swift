//
//  Extension.swift
//  CTV
//
//  Created by bhavin on 08/08/17.
//  Copyright © 2017 bhavin. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    func shiftRight( amount: Int = 1) -> [Element] {
        var amount = amount
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if amount < 0 { amount += count }  // this needs to be >= 0
        return Array(self[amount ..< count] + self[0 ..< amount])
    }
    
    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount: amount)
    }
}

/*extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(NSURL(string: url)! as URL) {
                application.openURL(NSURL(string: url)! as URL)
                return
            }
        }
    }
}*/

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                //application.openURL(URL(string: url)!)
                if #available(iOS 10.0, *) {
                    application.open(URL(string: url)!, options: [:], completionHandler: nil)
                } else {
                    application.openURL(URL(string: url)!)
                }
                return
            }
        }
    }
}
