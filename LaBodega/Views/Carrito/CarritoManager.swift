//
//  CarritoManager.swift
//  LaBodega
//
//  Created by DISEÑO on 9/05/25.
//

import FirebaseAuth
import FirebaseFirestore

class CarritoManager {
   
    static let shared = CarritoManager()
    
    private var carritoIDActual: String?

    func obtenerCarritoActivo(completion: @escaping (String?) -> Void) {
        if let id = carritoIDActual {
            completion(id)
            return
        }

        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let db = Firestore.firestore()
        db.collection("carritos")
            .whereField("usuario_id", isEqualTo: uid)
            .whereField("estado", isEqualTo: "abierto")
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let doc = snapshot?.documents.first {
                    self.carritoIDActual = doc.documentID
                    completion(doc.documentID)
                } else {
                    let nuevoRef = db.collection("carritos").document()
                    nuevoRef.setData([
                        "usuario_id": uid,
                        "fecha_creacion": FieldValue.serverTimestamp(),
                        "estado": "abierto"
                    ]) { err in
                        if err == nil {
                            self.carritoIDActual = nuevoRef.documentID
                        }
                        completion(nuevoRef.documentID)
                    }
                }
            }
    }

    func agregarVinoAlCarrito(vino: Vino, completion: ((Error?) -> Void)? = nil) {
        obtenerCarritoActivo { carritoID in
            guard let carritoID = carritoID else {
                completion?(NSError(domain: "Carrito", code: 1, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el carrito"]))
                return
            }

            let itemsRef = Firestore.firestore()
                .collection("carritos")
                .document(carritoID)
                .collection("items")
                .document(vino.documentID)

            itemsRef.setData([
                "vino_id": vino.documentID,
                "nombre": vino.nombre,
                "precio": vino.precio,
                "imagen_url": vino.imagenURL,
                "cantidad": FieldValue.increment(Int64(1))
            ], merge: true, completion: completion)
        }
    }
    
    func obtenerItemsDelCarrito(completion: @escaping ([CarritoItem]) -> Void) {
        obtenerCarritoActivo { carritoID in
            guard let carritoID = carritoID else {
                completion([])
                return
            }

            Firestore.firestore()
                .collection("carritos")
                .document(carritoID)
                .collection("items")
                .addSnapshotListener  { snapshot, error in
                    guard let documents = snapshot?.documents, error == nil else {
                        completion([])
                        return
                    }

                    let items = documents.compactMap { doc -> CarritoItem? in
                        let data = doc.data()
                        guard
                            let nombre = data["nombre"] as? String,
                            let precio = data["precio"] as? Double,
                            let cantidad = data["cantidad"] as? Int,
                            let imagenURL = data["imagen_url"] as? String
                        else { return nil }

                        return CarritoItem(vinoID: doc.documentID, nombre: nombre, precio: precio, cantidad: cantidad, imagenURL: imagenURL)
                    }

                    completion(items)
                }
        }
    }
    
    
    func actualizarCantidadDelItem(vinoID: String, nuevaCantidad: Int, completion: ((Error?) -> Void)? = nil) {
        obtenerCarritoActivo { carritoID in
            guard let carritoID = carritoID else {
                completion?(NSError(domain: "Carrito", code: 2, userInfo: [NSLocalizedDescriptionKey: "No se encontró el carrito"]))
                return
            }

            let itemRef = Firestore.firestore()
                .collection("carritos")
                .document(carritoID)
                .collection("items")
                .document(vinoID)

            itemRef.updateData(["cantidad": nuevaCantidad], completion: completion)
        }
    }
    
    func obtenerCantidadDeItemsUnicos(completion: @escaping (Int) -> Void) {
        obtenerItemsDelCarrito { items in
            let cantidadItemsUnicos = items.count
            completion(cantidadItemsUnicos)
        }
    }
    
    func finalizarCarrito(completion: ((Error?) -> Void)? = nil) {
        guard let carritoID = carritoIDActual else {
            completion?(NSError(domain: "Carrito", code: 3, userInfo: [NSLocalizedDescriptionKey: "No hay carrito activo para finalizar"]))
            return
        }

        let carritoRef = Firestore.firestore().collection("carritos").document(carritoID)
        
        carritoRef.updateData([
            "estado": "pendiente",
            "fecha_cotizacion": FieldValue.serverTimestamp()
        ]) { error in
            if error == nil {
                self.carritoIDActual = nil
            }
            completion?(error)
        }
    }


}
