//
//  PerfilAlertHelper .swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import Foundation
import UIKit

class PerfilAlertHelper {
    static func mostrar(mensaje: String, en viewController: UIViewController, titulo: String = "Aviso") {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}
