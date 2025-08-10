//
//  DetalleVinoCustomerViewController.swift
//  LaBodega
//
//  Created by jos on 9/05/25.
//

import UIKit

class DetalleVinoCustomerViewController: UIViewController {
    
    var vino: Vino?
    @IBOutlet weak var portadaImageView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vino = vino {
            nombreLabel.text = vino.nombre
            precioLabel.text = "S/. \(vino.precio)"
            stockLabel.text = "Stock: \(vino.stock)"
            descripcionLabel.text = vino.descripcion
            
            if let url = URL(string: vino.imagenURL) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.portadaImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func agregarAlCarritoTapped(_ sender: UIButton) {
        guard let vino = vino else { return }

              CarritoManager.shared.agregarVinoAlCarrito(vino: vino) { error in
                  if let error = error {
                      print("Error al agregar: \(error.localizedDescription)")
                  } else {
                      print("Vino agregado al carrito correctamente")
                  }
              }
          }
      }
