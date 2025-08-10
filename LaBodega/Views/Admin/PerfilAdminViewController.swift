//
//  PerfilAdminViewController.swift
//  LaBodega
//
//  Created by jos on 5/05/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PerfilAdminViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoTextField: UITextField!
    @IBOutlet weak var paisTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var guardarButton: UIButton!
    
    let viewModel = PerfilAdminViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarTextFields()
        configurarGuardarButton(habilitado: false)
        cargarDatosUsuario()
    }

    func configurarTextFields() {
        [nombreTextField, apellidoTextField, paisTextField, telefonoTextField].forEach {
            $0?.isUserInteractionEnabled = false
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(textFieldEditado), for: .editingChanged)
        }
    }

    func configurarGuardarButton(habilitado: Bool) {
        guardarButton.isEnabled = habilitado
        guardarButton.alpha = habilitado ? 1.0 : 0.5
    }

    func cargarDatosUsuario() {
        viewModel.obtenerDatos { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let datos):
                    self.nombreTextField.text = datos["nombre"]
                    self.apellidoTextField.text = datos["apellido"]
                    self.paisTextField.text = datos["pais"]
                    self.telefonoTextField.text = datos["telefono"]
                    self.emailLabel.text = Auth.auth().currentUser?.email ?? ""
                    [self.nombreTextField, self.apellidoTextField, self.paisTextField, self.telefonoTextField].forEach {
                        $0?.isUserInteractionEnabled = true
                    }
                case .failure(let error):
                    PerfilAlertHelper.mostrar(mensaje: error.localizedDescription, en: self)
                }
            }
        }
    }

    @objc func textFieldEditado(_ textField: UITextField) {
        let cambios = viewModel.detectarCambios(
            nombre: nombreTextField.text ?? "",
            apellido: apellidoTextField.text ?? "",
            pais: paisTextField.text ?? "",
            telefono: telefonoTextField.text ?? ""
        )
        configurarGuardarButton(habilitado: cambios)
    }

    @IBAction func guardarTapped(_ sender: UIButton) {
        viewModel.actualizarDatos { error in
            DispatchQueue.main.async {
                if let error = error {
                   PerfilAlertHelper.mostrar(mensaje: error.localizedDescription, en: self)
                } else {
                    self.configurarGuardarButton(habilitado: false)
                    PerfilAlertHelper.mostrar(mensaje: "Datos actualizados correctamente", en: self)
                }
            }
        }
    }

    @IBAction func cerrarSesionTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                loginVC.modalPresentationStyle = .fullScreen
                present(loginVC, animated: true)
            }
        } catch {
            PerfilAlertHelper.mostrar(mensaje: error.localizedDescription, en: self)
        }
    }
}
    
