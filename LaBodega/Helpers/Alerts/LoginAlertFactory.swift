//
//  LoginAlertFactory.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import UIKit
import FirebaseAuth

enum LoginAlertType {
    case camposVacios
    case usuarioNoEncontrado
    case errorAutenticacion(Error)
    case rolDesconocido
    case uidNoDisponible
}

class LoginAlertFactory {
    static func makeAlert(for type: LoginAlertType, on viewController: UIViewController, completion: (() -> Void)? = nil) {
        let title = "Error"
        var message = ""

        switch type {
        case .camposVacios:
            message = "Completa todos los campos."
        case .usuarioNoEncontrado:
            message = "No se encontró una cuenta con ese correo."
        case .errorAutenticacion(let error):
            let code = (error as NSError).code
            switch AuthErrorCode(rawValue: code) {
            case .wrongPassword:
                message = "Contraseña incorrecta."
            case .invalidEmail:
                message = "Formato de correo inválido."
            case .networkError:
                message = "Problemas de conexión a internet."
            default:
                message = error.localizedDescription
            }
        case .rolDesconocido:
            message = "Rol desconocido. Contacta al administrador."
        case .uidNoDisponible:
            message = "No se pudo obtener el ID del usuario."
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in completion?() })
        viewController.present(alert, animated: true)
    }
}
