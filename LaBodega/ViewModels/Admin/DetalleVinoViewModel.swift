//
//  DetalleVinoViewModel.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import Foundation

class DetalleVinoViewModel {
    var vino: Vino
    private let service = VinoService()

    private var datosOriginales: [String: String] = [:]

    var onDatosActualizados: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onGuardadoExitoso: (() -> Void)?

    init(vino: Vino) {
        self.vino = vino
        datosOriginales = [
            "nombre": vino.nombre,
            "descripcion": vino.descripcion,
            "precio": String(format: "%.2f", vino.precio),
            "stock": "\(vino.stock)"
        ]
    }

    func huboCambios(nombre: String, descripcion: String, precio: String, stock: String) -> Bool {
        return nombre != datosOriginales["nombre"] ||
               descripcion != datosOriginales["descripcion"] ||
               precio != datosOriginales["precio"] ||
               stock != datosOriginales["stock"]
    }

    func guardarCambios(nombre: String, descripcion: String, precio: String, stock: String) {
        let nuevosDatos: [String: Any] = [
            "nombre": nombre,
            "descripcion": descripcion,
            "precio": Double(precio) ?? 0.0,
            "stock": Int(stock) ?? 0
        ]

        service.actualizarVino(documentID: vino.documentID, datos: nuevosDatos) { [weak self] error in
            if let error = error {
                self?.onError?(error)
            } else {
                self?.onGuardadoExitoso?()
                self?.actualizarDatosOriginales(nombre: nombre, descripcion: descripcion, precio: precio, stock: stock)
            }
        }
    }

    private func actualizarDatosOriginales(nombre: String, descripcion: String, precio: String, stock: String) {
        datosOriginales = [
            "nombre": nombre,
            "descripcion": descripcion,
            "precio": precio,
            "stock": stock
        ]
    }
}
