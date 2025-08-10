//
//  UserService.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import FirebaseAuth
import FirebaseFirestore

class UserService {
    private let db = Firestore.firestore()

    func obtenerDatosUsuario(uid: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = document?.data() else {
                completion(.success([:])) 
                return
            }

            let userData: [String: String] = [
                "nombre": data["nombre"] as? String ?? "",
                "apellido": data["apellido"] as? String ?? "",
                "pais": data["pais"] as? String ?? "",
                "telefono": data["telefono"] as? String ?? ""
            ]
            completion(.success(userData))
        }
    }

    func actualizarDatosUsuario(uid: String, datos: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("users").document(uid).updateData(datos, completion: completion)
    }
}
