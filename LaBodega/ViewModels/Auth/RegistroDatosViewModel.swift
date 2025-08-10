//
//  RegistroDatosViewModel.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegistroDatosViewModel {
    
    var onError: ((Error) -> Void)?
    var onRegistroExitoso: (() -> Void)?
    func registrarUsuario(usuario: UsuarioTemporal) {
        FirebaseAuthService.shared.registrarUsuario(email: usuario.email, password: usuario.password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let uid):
                    self.guardarDatosEnFirestore(uid: uid, usuario: usuario)
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
    private func guardarDatosEnFirestore(uid: String, usuario: UsuarioTemporal) {
        FirestoreService.shared.guardarDatosUsuario(uid: uid,
                                                    correo: usuario.email,
                                                    nombre: usuario.nombre,
                                                    apellido: usuario.apellido,
                                                    pais: usuario.pais,
                                                    telefono: usuario.telefono) { error in
            if let error = error {
                self.onError?(error)
            } else {
                self.onRegistroExitoso?()
            }
        }
    }
}
