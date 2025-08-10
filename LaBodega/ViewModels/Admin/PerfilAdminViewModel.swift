//
//  PerfilAdminViewModel.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import FirebaseAuth

class PerfilAdminViewModel {
    var userService = UserService()
    var datosOriginales: [String: String] = [:]
    var datosActuales: [String: String] = [:]

    func obtenerDatos(completion: @escaping (Result<[String: String], Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "UIDError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se encontró UID."])))
            return
        }

        userService.obtenerDatosUsuario(uid: uid) { result in
            switch result {
            case .success(let datos):
                self.datosOriginales = datos
                self.datosActuales = datos
                completion(.success(datos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func actualizarDatos(completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let datos: [String: Any] = datosActuales
        userService.actualizarDatosUsuario(uid: uid, datos: datos) { error in
            if error == nil {
                self.datosOriginales = self.datosActuales
            }
            completion(error)
        }
    }

    func detectarCambios(nombre: String, apellido: String, pais: String, telefono: String) -> Bool {
        datosActuales["nombre"] = nombre
        datosActuales["apellido"] = apellido
        datosActuales["pais"] = pais
        datosActuales["telefono"] = telefono

        return datosActuales != datosOriginales
    }
}
