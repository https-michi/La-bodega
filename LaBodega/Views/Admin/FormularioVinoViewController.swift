//
//  FormularioVinoViewController.swift
//  LaBodega
//
//  Created by jos on 5/05/25.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class FormularioVinoViewController: BaseViewController {

    @IBOutlet weak var imagenPreview: UIImageView!
    @IBOutlet weak var nombreField: UITextField!
    @IBOutlet weak var descripcionField: UITextView!
    @IBOutlet weak var precioField: UITextField!
    @IBOutlet weak var stockField: UITextField!
    @IBOutlet var progressView: UIProgressView!

    var imagenSeleccionada: UIImage?
        var viewModel = FormularioVinoViewModel()

        override func viewDidLoad() {
            super.viewDidLoad()
            imagenPreview.image = imagenSeleccionada
            configurarViewModel()
            progressView.progress = 0.0
            progressView.isHidden = true
        }

        private func configurarViewModel() {
            viewModel.onProgreso = { [weak self] progreso in
                self?.progressView.isHidden = false
                self?.progressView.setProgress(progreso, animated: true)
            }

            viewModel.onFinalizado = { [weak self] in
                self?.progressView.isHidden = true
                if let self = self {
                    AdminAlertFactory.showAlert(for: .exitoCreacionVino("Vino creado correctamente."), on: self)
                }
                self?.tabBarController?.selectedIndex = 0

                if let listaVC = self?.tabBarController?.viewControllers?[0] as? ListaVinosAdminViewController {
                    listaVC.viewModel.fetchVinos()
                }
            }

            viewModel.onError = { [weak self] tipoAlerta in
                self?.progressView.isHidden = true
                AdminAlertFactory.showAlert(for: tipoAlerta, on: self!)
            }
        }

        @IBAction func crearVinoTapped(_ sender: Any) {
            guard
                let imagen = imagenSeleccionada,
                let nombre = nombreField.text, !nombre.isEmpty,
                let descripcion = descripcionField.text, !descripcion.isEmpty,
                let precioStr = precioField.text, let precio = Double(precioStr),
                let stockStr = stockField.text, let stock = Int(stockStr)
            else {
                AdminAlertFactory.showAlert(for: .errorCreacionVino("Todos los campos son obligatorios."), on: self)
                return
            }

            viewModel.crearVino(nombre: nombre, descripcion: descripcion, precio: precio, stock: stock, imagen: imagen)
        }
    }

    

