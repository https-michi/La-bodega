//
//  VinoServiceError.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import Foundation

enum VinoServiceError: Error {
    case snapshotInvalido
    case errorDesconocido
    case sinDatos
    case falloSubida
    case falloCreacion(String)
    
    var descripcion: String {
        switch self {
        case .snapshotInvalido:
            return "La respuesta de la base de datos es inválida."
        case .errorDesconocido:
            return "Ha ocurrido un error desconocido."
        case .sinDatos:
            return "No se encontraron vinos."
        case .falloSubida:
            return "Error al subir la imagen."
        case .falloCreacion(let mensaje):
            return "Error al crear el vino: \(mensaje)"
        }
    }
}
