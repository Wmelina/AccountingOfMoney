//
//  Actions.swift
//  Accounting Of Money
//
//  Created by Alexandr Kurdyukov on 02.04.2018.
//  Copyright © 2018 Alexandr Kurdyukov. All rights reserved.
//

import UIKit

class Actions: NSObject {
    
    func showWarningAlert(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    return alert
    }
    
}
