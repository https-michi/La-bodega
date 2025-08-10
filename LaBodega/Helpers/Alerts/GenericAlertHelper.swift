//
//  GenericAlertHelper.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import UIKit

class GenericAlertHelper {
    static func showAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        viewController.present(alert, animated: true)
    }
}
