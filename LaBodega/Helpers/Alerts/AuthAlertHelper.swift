//
//  AuthAlertHelper.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import UIKit
import FirebaseAuth

class AuthAlertHelper {
    static func showAuthError(on viewController: UIViewController, error: Error) {
        let code = (error as NSError).code
        var message = "Ha ocurrido un error."

        switch AuthErrorCode(rawValue: code) {
        case .userNotFound:
            message = "No hay una cuenta registrada con este correo."
        case .wrongPassword:
            message = "La contraseña ingresada no es válida."
        case .emailAlreadyInUse:
            message = "Ya existe una cuenta con este correo."
        case .invalidEmail:
            message = "El formato del correo electrónico no es válido."
        case .accountExistsWithDifferentCredential:
            message = "Ya existe una cuenta vinculada a otro proveedor con este correo."
        case .operationNotAllowed:
            message = "La operación no está permitida."
        case .userDisabled:
            message = "Esta cuenta ha sido deshabilitada."
        case .weakPassword:
            message = "La contraseña es demasiado débil."
        case .networkError:
            message = "Problemas con la conexión de red."
        case .tooManyRequests:
            message = "Demasiados intentos. Inténtalo nuevamente más tarde."
        default:
            message = error.localizedDescription 
        }

        GenericAlertHelper.showAlert(on: viewController, message: message)
    }
}
