//
//  AppConstant.swift
//  CTV
//
//  Created by bhavin on 28/07/17.
//  Copyright © 2017 bhavin. All rights reserved.
//

import Foundation
import UIKit

public class AlertShow {
    class func showAlert(title: String, message: String, in vc: UIViewController) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
}
