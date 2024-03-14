import SwiftUI

struct Navbar: View {
    var festival: Festival

    var body: some View {
            VStack {
                NavigationLink(destination: ListeJeuView(festival: festival)) {
                    Text("Jeux")
                }
                NavigationLink(destination: ListePosteView(festival: festival)) {
                    Text("Postes")
                }
                NavigationLink(destination: ListeInscriptionView(festival: festival)) {
                    Text("Inscription")
                }
            }
        }
}
