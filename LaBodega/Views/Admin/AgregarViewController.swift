//
//  AgregarViewController.swift
//  LaBodega
//
//  Created by jos on 5/05/25.
//

import UIKit
import PhotosUI

class AgregarViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mostrarGaleria()
    }

    func mostrarGaleria() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension AgregarViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let result = results.first else {
            tabBarController?.selectedIndex = 0
            return
        }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            guard let self = self, let imagen = object as? UIImage else { return }

            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let formularioVC = storyboard.instantiateViewController(withIdentifier: "FormularioVinoViewController") as? FormularioVinoViewController {
                    formularioVC.imagenSeleccionada = imagen
                    self.navigationController?.pushViewController(formularioVC, animated: true)
                }
            }
        }
    }
}
    
    
