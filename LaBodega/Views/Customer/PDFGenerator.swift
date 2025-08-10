//
//  PDFGenerator.swift
//  LaBodega
//
//  Created by jos on 10/05/25.
//

import UIKit
import PDFKit
import FirebaseAuth

class PDFGenerator {

    static func generarCotizacionPDF(items: [CarritoItem], total: Double, completion: @escaping (URL?) -> Void) {
        let pdfMetaData = [
            kCGPDFContextCreator: "LaBodega App",
            kCGPDFContextAuthor: "LaBodega App"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 612.0
        let pageHeight = 792.0
        let margin: CGFloat = 40.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let fileName = "Cotizacion_\(Int(Date().timeIntervalSince1970)).pdf"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try renderer.writePDF(to: fileURL) { context in
                context.beginPage()

                let titleFont = UIFont.boldSystemFont(ofSize: 24)
                let headerFont = UIFont.boldSystemFont(ofSize: 16)
                let bodyFont = UIFont.systemFont(ofSize: 14)

                var y: CGFloat = margin

                if let logo = UIImage(named: "LogoLaBodega") {
                    logo.draw(in: CGRect(x: margin, y: y, width: 100, height: 50))
                }

                let titulo = "Cotización de Productos"
                let tituloAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
                let tituloSize = titulo.size(withAttributes: tituloAttributes)
                titulo.draw(at: CGPoint(x: (pageWidth - tituloSize.width) / 2, y: y), withAttributes: tituloAttributes)
                y += 70

                if let user = Auth.auth().currentUser {
                    let cliente = "Cliente: \(user.email ?? "Sin email")"
                    cliente.draw(at: CGPoint(x: margin, y: y), withAttributes: [.font: bodyFont])
                    y += 30
                }

                let encabezado = "Producto".padding(toLength: 25, withPad: " ", startingAt: 0) +
                                 "Cantidad".padding(toLength: 10, withPad: " ", startingAt: 0) +
                                 "Precio Total"
                encabezado.draw(at: CGPoint(x: margin, y: y), withAttributes: [.font: headerFont])
                y += 25

                context.cgContext.move(to: CGPoint(x: margin, y: y))
                context.cgContext.addLine(to: CGPoint(x: pageWidth - margin, y: y))
                context.cgContext.strokePath()
                y += 10

                for item in items {
                    let nombre = item.nombre.padding(toLength: 25, withPad: " ", startingAt: 0)
                    let cantidad = "x\(item.cantidad)".padding(toLength: 10, withPad: " ", startingAt: 0)
                    let precio = "S/ \(String(format: "%.2f", item.precio * Double(item.cantidad)))"

                    let linea = nombre + cantidad + precio
                    linea.draw(at: CGPoint(x: margin, y: y), withAttributes: [.font: bodyFont])
                    y += 20

                    if y > pageHeight - margin - 50 {
                        context.beginPage()
                        y = margin
                    }
                }

                y += 20
                let totalStr = "Total: S/ \(String(format: "%.2f", total))"
                totalStr.draw(at: CGPoint(x: margin, y: y), withAttributes: [.font: UIFont.boldSystemFont(ofSize: 18)])
            }

            completion(fileURL)
        } catch {
            print("Error al generar PDF: \(error)")
            completion(nil)
        }
    }
}

