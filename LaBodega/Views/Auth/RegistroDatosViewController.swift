//
//  RegistroDatosViewController.swift
//  LaBodega
//
//  Created by jos on 3/05/25.
//

import UIKit
import FirebaseAuth

class RegistroDatosViewController: UIViewController {
    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var paisTextField: UITextField!
    
    var usuarioTemporal: UsuarioTemporal?

    private let viewModel = RegistroDatosViewModel()

     override func viewDidLoad() {
         super.viewDidLoad()
         habilitarOcultarTeclado()
         bindViewModel()
     }
     
    
    @IBAction func backLogin(_ sender: UIButton) {
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
    }
    

     private func bindViewModel() {
         viewModel.onError = { [weak self] error in
             guard let self = self else { return }
             AuthAlertHelper.showAuthError(on: self, error: error)

         }

         viewModel.onRegistroExitoso = { [weak self] in
             guard let self = self else { return }
             AlertHelper.showAlert(on: self, message: "¡Registro completo!") {
                 self.irAlHomeCliente()
             }
         }
     }

     @IBAction func guardarTapped(_ sender: Any) {
         guard let nombre = nombreTextField.text,
               let apellido = apellidoTextField.text,
               let pais = paisTextField.text,
               let telefono = telefonoTextField.text,
               !nombre.isEmpty, !apellido.isEmpty, !pais.isEmpty, !telefono.isEmpty,
               var usuario = usuarioTemporal else {
             RegistroAlertFactory.makeAlert(for: .camposVacios, on: self)
             return
         }

         usuario.nombre = nombre
         usuario.apellido = apellido
         usuario.pais = pais
         usuario.telefono = telefono

         viewModel.registrarUsuario(usuario: usuario)
     }

     func irAlHomeCliente() {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarCustomerController") as? UITabBarController {
             tabBarController.modalPresentationStyle = .fullScreen
             self.present(tabBarController, animated: true, completion: nil)
         }
     }
 }


    
    
    
    
    
    


