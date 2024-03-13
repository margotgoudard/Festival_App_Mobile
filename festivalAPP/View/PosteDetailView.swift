import SwiftUI

struct PosteDetailView: View {
    let poste: Poste

    var body: some View {
        Text(poste.description ?? "Pas de description disponible")
            .navigationTitle(poste.nom)
    }
}
