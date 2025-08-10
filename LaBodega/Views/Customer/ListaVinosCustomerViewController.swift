//
//  ListaVinosCustomerViewController.swift
//  LaBodega
//
//  Created by jos on 3/05/25.
//
import UIKit
import SwiftUI


class ListaVinosCustomerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = MasonryLayoutView(onVinoSelected: { [weak self] vino in
            self?.mostrarDetalle(vino: vino)
        })

        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        hostingController.didMove(toParent: self)
    }
    
    private func mostrarDetalle(vino: Vino) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detalleVC = storyboard.instantiateViewController(withIdentifier: "DetalleVinoCustomerViewController") as? DetalleVinoCustomerViewController {
            detalleVC.vino = vino
            self.navigationController?.pushViewController(detalleVC, animated: true)
        }
    }
}

