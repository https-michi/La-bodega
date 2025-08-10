//
//  ListaItemsCarritoViewController.swift
//  LaBodega
//
//  Created by jos on 10/05/25.
//

import UIKit

class ListaItemsCarritoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!

    var items: [CarritoItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        cargarItemsDelCarrito()
    }

    func cargarItemsDelCarrito() {
        CarritoManager.shared.obtenerItemsDelCarrito { items in
            DispatchQueue.main.async {
                self.items = items
                self.tableView.reloadData()
                self.totalLabel.text = String(format: "Total: S/ %.2f", self.calcularTotalDelCarrito())
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCarritoCell", for: indexPath) as! ItemCarritoTableViewCell
        cell.configure(with: item)

        cell.onCantidadCambiada = { [weak self] nuevaCantidad in
            CarritoManager.shared.actualizarCantidadDelItem(vinoID: item.vinoID, nuevaCantidad: nuevaCantidad) { error in
                if let error = error {
                    print("Error al actualizar cantidad: \(error.localizedDescription)")
                } else {
                    self?.items[indexPath.row].cantidad = nuevaCantidad
                    self?.totalLabel.text = String(format: "Total: S/ %.2f", self?.calcularTotalDelCarrito() ?? 0)
                }
            }
        }

        return cell
    }

    func calcularTotalDelCarrito() -> Double {
        return items.reduce(0) { $0 + ($1.precio * Double($1.cantidad)) }
    }

    @IBAction func cotizarButtonTapped(_ sender: UIButton) {
        let total = calcularTotalDelCarrito()

        PDFGenerator.generarCotizacionPDF(items: self.items, total: total) { url in
            guard let url = url else {
                DispatchQueue.main.async {
                    self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo generar el PDF")
                }
                return
            }

            DispatchQueue.main.async {
                let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self.present(activityVC, animated: true)
            }

            CarritoManager.shared.finalizarCarrito { error in
                DispatchQueue.main.async {
                    self.items = []
                    self.tableView.reloadData()
                    self.totalLabel.text = "Total: S/ 0.00"
                }
            }
        }
    }

    func mostrarAlerta(titulo: String, mensaje: String) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
