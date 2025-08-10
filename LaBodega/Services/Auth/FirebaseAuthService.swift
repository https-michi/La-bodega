//
//  FirebaseAuthService.swift
//  LaBodega
//
//  Created by jos on 3/05/25.
//

import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthService {
    
    static let shared = FirebaseAuthService()
    
    private init() {}
    
    func registrarUsuario(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let uid = result?.user.uid {
                completion(.success(uid))
            }
        }
    }
    
    func iniciarSesion(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func inicializarAdminSiEsNecesario() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.crearUsuarioAdminSiNoExiste()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func crearUsuarioAdminSiNoExiste() {
        let adminEmail = "josesullcapuma10@gmail.com"
        let adminPassword = "LaBodegaApp"
        
        Auth.auth().fetchSignInMethods(forEmail: adminEmail) { methods, error in
            if let error = error {
                print("Error verificando existencia del admin: \(error.localizedDescription)")
                return
            }
            
            if let methods = methods, !methods.isEmpty {
                print("El usuario admin ya existe.")
                return
            }
            
            self.registrarUsuario(email: adminEmail, password: adminPassword) { result in
                switch result {
                case .success(let uid):
                    let adminData: [String: Any] = [
                        "uid": uid,
                        "correo": adminEmail,
                        "nombre": "José",
                        "apellido": "Sullca Puma",
                        "pais": "Perú",
                        "telefono": "000000000",
                        "fecha_registro": Timestamp(date: Date()),
                        "id_rol": Firestore.firestore().document("roles/0")
                    ]
                    
                    Firestore.firestore().collection("users").document(uid).setData(adminData) { error in
                        if let error = error {
                            print("Error creando admin en Firestore: \(error.localizedDescription)")
                        } else {
                            print("Admin creado correctamente en Firestore")
                        }
                    }
                case .failure(let error):
                    print("Error registrando admin: \(error.localizedDescription)")
                }
            }
        }
    }
}
