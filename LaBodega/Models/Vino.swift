//
//  Vino.swift
//  LaBodega
//
//  Created by jos on 6/05/25.
//

import Foundation
import FirebaseFirestore

struct Vino {
    let nombre: String
    let descripcion: String
    let imagenURL: String
    let precio: Double
    let stock: Int
    let documentID: String
    let fechaSubida: Date?

    init?(document: [String: Any], documentID: String) {
        guard let nombre = document["nombre"] as? String,
              let descripcion = document["descripcion"] as? String,
              let imagenURL = document["imagen_url"] as? String,
              let precio = document["precio"] as? Double,
              let stock = document["stock"] as? Int else {
            return nil
        }
        let timestamp = document["fecha_subida"] as? Timestamp
        self.nombre = nombre
        self.descripcion = descripcion
        self.imagenURL = imagenURL
        self.precio = precio
        self.stock = stock
        self.documentID = documentID
        self.fechaSubida = timestamp?.dateValue()
    }
}
