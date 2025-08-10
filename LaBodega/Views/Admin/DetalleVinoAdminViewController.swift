//
//  DetalleVinoAdminViewController.swift
//  LaBodega
//
//  Created by jos on 7/05/25.
//

import UIKit
import FirebaseFirestore


class DetalleVinoAdminViewController: BaseViewController ,UITextFieldDelegate,  UITextViewDelegate {

    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var precioTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var descripcionTextField: UITextView!
    @IBOutlet weak var vinoImageView: UIImageView!
    @IBOutlet weak var fechaSubidaLabel: UILabel!
    @IBOutlet weak var guardarButton: UIButton!

    var viewModel: DetalleVinoViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        mostrarDetalle()
        configurarTextFields()
        configurarGuardarButton(habilitado: false)
        configurarCallbacks()
    }

    private func configurarCallbacks() {
        viewModel.onGuardadoExitoso = { [weak self] in
            DispatchQueue.main.async {
                RegistroAlertFactory.mostrarAlerta(
                    titulo: "Éxito",
                    mensaje: "El vino se actualizó correctamente.",
                    en: self!
                )
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }

        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                RegistroAlertFactory.mostrarAlerta(
                    titulo: "Error",
                    mensaje: error.localizedDescription,
                    en: self!
                )
            }
        }
    }


    func configurarTextFields() {
        [nombreTextField, precioTextField, stockTextField].forEach {
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(textFieldEditado), for: .editingChanged)
        }
        descripcionTextField.delegate = self
    }

    func configurarGuardarButton(habilitado: Bool) {
        guardarButton.isEnabled = habilitado
        guardarButton.alpha = habilitado ? 1.0 : 0.5
    }

    @objc func textFieldEditado(_ textField: UITextField?) {
        evaluarCambios()
    }

    func textViewDidChange(_ textView: UITextView) {
        evaluarCambios()
    }

    func evaluarCambios() {
        let nombre = nombreTextField.text ?? ""
        let descripcion = descripcionTextField.text ?? ""
        let precio = precioTextField.text ?? ""
        let stock = stockTextField.text ?? ""

        let cambios = viewModel.huboCambios(nombre: nombre, descripcion: descripcion, precio: precio, stock: stock)
        configurarGuardarButton(habilitado: cambios)
    }

    func mostrarDetalle() {
        let vino = viewModel.vino
        nombreTextField.text = vino.nombre
        descripcionTextField.text = vino.descripcion
        precioTextField.text = String(format: "%.2f", vino.precio)
        stockTextField.text = "\(vino.stock)"

        if let fecha = vino.fechaSubida {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            fechaSubidaLabel.text = formatter.string(from: fecha)
        }

        if let url = URL(string: vino.imagenURL) {
            vinoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
    }

    @IBAction func guardarTapped(_ sender: UIButton) {
        viewModel.guardarCambios(
            nombre: nombreTextField.text ?? "",
            descripcion: descripcionTextField.text ?? "",
            precio: precioTextField.text ?? "",
            stock: stockTextField.text ?? ""
        )
    }
}
    
    
