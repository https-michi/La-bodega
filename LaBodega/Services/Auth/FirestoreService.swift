//
//  FirestoreService.swift
//  LaBodega
//
//  Created by jos on 3/05/25.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    private init() {}

    func guardarDatosUsuario(uid: String, correo: String, nombre: String, apellido: String, pais: String, telefono: String, completion: @escaping (Error?) -> Void) {
        let datos: [String: Any] = [
            "uid": uid,
            "correo": correo,
            "nombre": nombre,
            "apellido": apellido,
            "pais": pais,
            "telefono": telefono,
            "fecha_registro": Timestamp(date: Date()),
            "id_rol": Firestore.firestore().document("roles/1")
        ]

        Firestore.firestore().collection("users").document(uid).setData(datos, completion: completion)
    }
}
