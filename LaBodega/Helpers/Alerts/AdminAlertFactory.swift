//
//  AdminAlertFactory.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import Foundation
import UIKit

import UIKit
enum AdminAlertType {
    case errorCargaVinos(String)
    case errorCreacionVino(String)
    case exitoCreacionVino(String)

    var titulo: String {
        switch self {
        case .errorCargaVinos, .errorCreacionVino:
            return "Error"
        case .exitoCreacionVino:
            return "Éxito"
        }
    }

    var mensaje: String {
        switch self {
        case .errorCargaVinos(let msg),
             .errorCreacionVino(let msg),
             .exitoCreacionVino(let msg):
            return msg
        }
    }
}


class AdminAlertFactory {
    static func showAlert(for tipo: AdminAlertType, on controller: UIViewController) {
        let alert = UIAlertController(title: tipo.titulo, message: tipo.mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        controller.present(alert, animated: true)
    }
}

