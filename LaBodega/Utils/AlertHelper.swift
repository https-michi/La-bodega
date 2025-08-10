//
//  AlertHelper.swift
//  LaBodega
//
//  Created by jos on 3/05/25.
//

import Foundation
import UIKit

class AlertHelper {
    static func showAlert(on viewController: UIViewController, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Atención", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        viewController.present(alert, animated: true, completion: nil)
    }
}

