import SwiftUI

struct EspaceDetailView: View {
    let espace: Espace
    let jeux:[Jeu]

    var body: some View {
            VStack {
                Text(espace.nom)
                    .navigationTitle(espace.nom)

                List(jeux) { jeu in
                    VStack(alignment: .leading) {
                        Text(jeu.nom)
                            .font(.headline)
                        Text("Reçu: \(jeu.recu ? "Oui" : "Non")")
                        Text("Notice: \(jeu.notice ?? "Non disponible")")
                    }
                }
            }
        }
    
}
