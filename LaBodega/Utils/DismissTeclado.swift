//
//  DismissTeclado.swift
//  LaBodega
//
//  Created by jos on 3/05/25.
//

import UIKit


class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        habilitarOcultarTeclado()
    }
}
extension UIViewController {
    func habilitarOcultarTeclado() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTeclado))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissTeclado() {
        view.endEditing(true)
    }
}
