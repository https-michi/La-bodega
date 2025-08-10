//
//  RegistroAlertFactory.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//
import UIKit

enum RegistroAlertType {
    case camposVacios
    case usuarioYaRegistrado
    case errorAutenticacion(Error)
    case datosIncompletos
    case precioInvalido
    case stockInvalido
    case errorGuardado(String)
}

class RegistroAlertFactory {
    static func makeAlert(for type: RegistroAlertType, on viewController: UIViewController, completion: (() -> Void)? = nil) {
        var title = "Error"
        var message = ""

        switch type {
        case .camposVacios:
            message = "Por favor, completa todos los campos."
        case .usuarioYaRegistrado:
            message = "Este correo ya está registrado."
        case .errorAutenticacion(let error):
            message = error.localizedDescription
        case .datosIncompletos:
            message = "Los datos ingresados son incompletos. Verifica."
        case .precioInvalido:
            message = "Ingresa un precio válido mayor a 0."
        case .stockInvalido:
            message = "Ingresa un stock válido (0 o mayor)."
        case .errorGuardado(let error):
            message = "Error al guardar: \(error)"
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in completion?() })
        viewController.present(alert, animated: true)
    }
    
    static func mostrarAlerta(titulo: String, mensaje: String, en viewController: UIViewController, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in completion?() })
        viewController.present(alert, animated: true)
    }

}
