//
//  VinoViewModel.swift
//  LaBodega
//
//  Created by jos on 8/05/25.
//

import Foundation
import FirebaseFirestore

struct VinoIdentificable: Identifiable {
    let id: String
    let vino: Vino
}

class VinoViewModel: ObservableObject {
    @Published var vinos: [VinoIdentificable] = []
    @Published var searchText: String = ""
    private var db = Firestore.firestore()
    
    init() {
        fetchVinos()
    }
    
    func fetchVinos() {
        db.collection("vinos").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            self.vinos = documents.compactMap { doc in
                if let vino = Vino(document: doc.data(), documentID: doc.documentID) {
                    return VinoIdentificable(id: doc.documentID, vino: vino)
                }
                return nil
            }
        }
    }
}

