//
//  ListaVinosAdminViewModel.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import Foundation
import FirebaseFirestore


class ListaVinosAdminViewModel {
    var vinos: [Vino] = []
    var onVinosActualizados: (() -> Void)?
    var onError: ((AdminAlertType) -> Void)?

    private let vinoService = VinoService()

    func fetchVinos() {
        vinoService.obtenerVinos { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let vinos):
                self.vinos = vinos
                self.onVinosActualizados?()
            case .failure(let error):
                let mensaje = (error as? VinoServiceError)?.descripcion ?? error.localizedDescription
                self.onError?(.errorCargaVinos(mensaje))
            }
        }
    }

    func vino(at index: Int) -> Vino {
        return vinos[index]
    }

    func numeroDeVinos() -> Int {
        return vinos.count
    }
}

