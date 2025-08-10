//
//  MasonryLayoutView.swift
//  LaBodega
//
//  Created by jos on 8/05/25.
//

import SwiftUI

struct VinoItemView: View {
    let vino: Vino

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: vino.imagenURL)) { phase in
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 200)

                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(3/4, contentMode: .fit)
                            //.frame(height: 200)
                            .clipped()
                            .cornerRadius(12)
                    } else if phase.error != nil {
                        Image(systemName: "xmark.octagon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .foregroundColor(.red)
                    } else {
                        ProgressView()
                    }
                }
            }

            Text(vino.nombre)
                .font(.headline)
                .foregroundColor(.white)

            Text("S/. \(vino.precio, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(8)
        .background(Color(red: 73/255, green: 20/255, blue: 18/255))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

//
//import SwiftUI
//import SDWebImageSwiftUI
//
//struct VinoItemView: View {
//    let vino: Vino
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            ZStack {
//                Rectangle()
//                    .fill(Color.white)
//                    .frame(height: 200)
//
//                WebImage(url: URL(string: vino.imagenURL))
//                    .onSuccess { _, _, _ in
//                    }
//                    .resizable()
//                    .placeholder {
//                        VStack {
//                            ProgressView()
//                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
//                                .frame(height: 50)
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.white)
//                    }
//                    .indicator(.activity)
//                    .transition(.fade(duration: 0.5))
//                    .aspectRatio(3/4, contentMode: .fit)
//                    .clipped()
//                    .cornerRadius(12)
//            }
//
//            Text(vino.nombre)
//                .font(.headline)
//                .foregroundColor(.white)
//
//            Text("S/. \(vino.precio, specifier: "%.2f")")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//        }
//        .padding(8)
//        .background(Color(red: 73/255, green: 20/255, blue: 18/255))
//        .cornerRadius(10)
//        .shadow(radius: 2)
//    }
//}
