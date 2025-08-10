//
//  FormularioVinoViewModel.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import UIKit

class FormularioVinoViewModel {
    var onProgreso: ((Float) -> Void)?
    var onFinalizado: (() -> Void)?
    var onError: ((AdminAlertType) -> Void)?

    private let vinoService = VinoService()

    func crearVino(nombre: String, descripcion: String, precio: Double, stock: Int, imagen: UIImage) {
        vinoService.crearVino(
            nombre: nombre,
            descripcion: descripcion,
            precio: precio,
            stock: stock,
            imagen: imagen,
            progressHandler: { [weak self] progreso in
                self?.onProgreso?(progreso)
            },
            completion: { [weak self] resultado in
                DispatchQueue.main.async {
                    switch resultado {
                    case .success:
                        self?.onFinalizado?()
                    case .failure(let error):
                        let mensaje = (error as? VinoServiceError)?.descripcion ?? error.localizedDescription
                        self?.onError?(.errorCreacionVino(mensaje))
                    }
                }
            }
        )
    }
}
