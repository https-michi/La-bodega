//
//  LoginViewController.swift
//  LaBodega
//
//  Created by jos on 2/05/25.
//


import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FBSDKLoginKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let viewModel = LoginViewModel()

       override func viewDidLoad() {
           super.viewDidLoad()
           bindViewModel()
       }

       private func bindViewModel() {
           viewModel.onError = { [weak self] error in
               guard let self = self else { return }
               LoginAlertFactory.makeAlert(for: .errorAutenticacion(error), on: self)
           }

           viewModel.onNavigateToRegister = { [weak self] usuarioTemporal in
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               if let registroVC = storyboard.instantiateViewController(withIdentifier: "RegistroDatosViewController") as? RegistroDatosViewController {
                   registroVC.usuarioTemporal = usuarioTemporal
                   registroVC.modalPresentationStyle = .fullScreen
                   self?.present(registroVC, animated: true, completion: nil)
               }
           }

           viewModel.onLoginSuccess = { [weak self] rolID in
               guard let self = self else { return }
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               if rolID == "0" {
                   if let adminVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarAdminController") as? UITabBarController {
                       adminVC.modalPresentationStyle = .fullScreen
                       self.present(adminVC, animated: true, completion: nil)
                   }
               } else if rolID == "1" {
                   if let customerVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarCustomerController") as? UITabBarController {
                       customerVC.modalPresentationStyle = .fullScreen
                       self.present(customerVC, animated: true, completion: nil)
                   }
               } else {
                   LoginAlertFactory.makeAlert(for: .rolDesconocido, on: self)
               }
           }
       }
    
       @IBAction func continuarTapped(_ sender: UIButton) {
           guard let email = emailTextField.text, let password = passwordTextField.text else { return }
           viewModel.continuar(email: email, password: password)
       }

   }
