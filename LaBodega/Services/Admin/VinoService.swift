//
//  VinoService.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage


class VinoService {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    func obtenerVinos(listener: @escaping (Result<[Vino], Error>) -> Void) {
        db.collection("vinos").addSnapshotListener { snapshot, error in
            if let error = error {
                listener(.failure(error))
                return
            }

            guard let snapshot = snapshot else {
                listener(.failure(VinoServiceError.snapshotInvalido))
                return
            }

            let vinos = snapshot.documents.compactMap {
                Vino(document: $0.data(), documentID: $0.documentID)
            }

            if vinos.isEmpty {
                listener(.failure(VinoServiceError.sinDatos))
                return
            }

            listener(.success(vinos))
        }
    }

    func crearVino(nombre: String, descripcion: String, precio: Double, stock: Int, imagen: UIImage, progressHandler: @escaping (Float) -> Void, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imageData = imagen.jpegData(compressionQuality: 0.15) else {
            completion(.failure(VinoServiceError.falloSubida))
            return
        }

        let uniqueImageName = UUID().uuidString + ".jpg"
        let storageRef = storage.reference().child("vinos/\(uniqueImageName)")
        let uploadTask = storageRef.putData(imageData, metadata: nil)

        uploadTask.observe(.progress) { snapshot in
            if let progress = snapshot.progress {
                let porcentaje = Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
                progressHandler(porcentaje)
            }
        }

        uploadTask.observe(.success) { _ in
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(VinoServiceError.falloSubida))
                    return
                }

                self.db.collection("vinos").addDocument(data: [
                    "nombre": nombre,
                    "descripcion": descripcion,
                    "precio": precio,
                    "stock": stock,
                    "imagen_url": downloadURL.absoluteString,
                    "fecha_subida": Timestamp(date: Date())
                ]) { error in
                    if let error = error {
                        completion(.failure(VinoServiceError.falloCreacion(error.localizedDescription)))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }

        uploadTask.observe(.failure) { snapshot in
            completion(.failure(snapshot.error ?? VinoServiceError.falloSubida))
        }
    }
    
    func actualizarVino(documentID: String, datos: [String: Any], completion: @escaping (Error?) -> Void) {
           db.collection("vinos").document(documentID).updateData(datos, completion: completion)
       }
    
}
