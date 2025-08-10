//
//  LoginViewModel.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel {
    
    var onError: ((Error) -> Void)?
    var onNavigateToRegister: ((UsuarioTemporal) -> Void)?
    var onLoginSuccess: ((String) -> Void)?
    
   
    private func iniciarSesion(email: String, password: String) {
        FirebaseAuthService.shared.iniciarSesion(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let uid = Auth.auth().currentUser?.uid else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el UID."])
                        self.onError?(error)
                        return
                    }
                    self.verificarRolUsuario(uid: uid)
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }

    private func verificarRolUsuario(uid: String) {
        let userDocRef = Firestore.firestore().collection("users").document(uid)
        userDocRef.getDocument { document, error in
            if let error = error {
                self.onError?(error)
                return
            }

            guard let document = document, document.exists,
                  let rolRef = document.get("id_rol") as? DocumentReference else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se encontró el rol del usuario."])
                self.onError?(error)
                return
            }

            rolRef.getDocument { rolDoc, error in
                if let error = error {
                    self.onError?(error)
                    return
                }

                guard let rolDoc = rolDoc, rolDoc.exists else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "El documento de rol no existe."])
                    self.onError?(error)
                    return
                }

                let rolID = rolDoc.documentID
                self.onLoginSuccess?(rolID)
            }
        }
    }
    
    func continuar(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            onError?(NSError(domain: "", code: AuthErrorCode.invalidEmail.rawValue, userInfo: [NSLocalizedDescriptionKey: "Completa todos los campos."]))
            return
        }


        Auth.auth().fetchSignInMethods(forEmail: email) { methods, error in
            if let error = error {
                self.onError?(error)
                return
            }

            if let methods = methods, !methods.isEmpty {
                self.iniciarSesion(email: email, password: password)
            } else {
                let nuevoUsuario = UsuarioTemporal(email: email, password: password, nombre: "", apellido: "", pais: "", telefono: "")
                self.onNavigateToRegister?(nuevoUsuario)
            }
        }
    }
}
