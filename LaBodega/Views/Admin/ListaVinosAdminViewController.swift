//
//  ListaVinosAdminViewController.swift
//  LaBodega
//
//  Created by jos on 3/05/25.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImage

class ListaVinosAdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    
        var viewModel = ListaVinosAdminViewModel()

        override func viewDidLoad() {
            super.viewDidLoad()
            configurarTabla()
            configurarViewModel()
            viewModel.fetchVinos()
        }

        private func configurarTabla() {
            tableView.delegate = self
            tableView.dataSource = self
        }

        private func configurarViewModel() {
            viewModel.onVinosActualizados = { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }

            viewModel.onError = { [weak self] tipoAlerta in
                guard let self = self else { return }
                AdminAlertFactory.showAlert(for: tipoAlerta, on: self)
            }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.numeroDeVinos()
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let vino = viewModel.vino(at: indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "VinoCell", for: indexPath) as! VinoTableViewCell
            cell.nombreLabel.text = vino.nombre
            cell.stockLabel.text = "\(vino.stock)"

            if let url = URL(string: vino.imagenURL) {
                cell.vinoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vinoSeleccionado = viewModel.vino(at: indexPath.row)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detalleVC = storyboard.instantiateViewController(withIdentifier: "DetalleVinoAdminViewController") as? DetalleVinoAdminViewController {
                detalleVC.viewModel = DetalleVinoViewModel(vino: vinoSeleccionado)
                navigationController?.pushViewController(detalleVC, animated: true)
            }
        }
    }
