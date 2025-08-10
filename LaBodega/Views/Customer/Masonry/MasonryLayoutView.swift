//
//  MasonryLayoutView.swift
//  LaBodega
//
//  Created by jos on 8/05/25.
//


import SwiftUI
import WaterfallGrid

struct MasonryLayoutView: View {
    @StateObject var viewModel = VinoViewModel()
    
    var onVinoSelected: ((Vino) -> Void)? = nil

    var body: some View {
        ScrollView {
            WaterfallGrid(viewModel.vinos) { item in
                if item.id == viewModel.vinos.first?.id {
                    AnyView(
                        Text("Vinos")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                    )
                } else {
                  
                    AnyView(
                        VinoItemView(vino: item.vino)
                                .onTapGesture {
                                 onVinoSelected?(item.vino)
                        }
                    )
                }
            }
            .gridStyle(
                columnsInPortrait: 2,
                columnsInLandscape: 3,
                spacing: 12,
                animation: .easeInOut(duration: 0.5)
            )
            .padding(.horizontal)
        }
        .background(Color(.black))
    }
}

#Preview {
    MasonryLayoutView()
}
