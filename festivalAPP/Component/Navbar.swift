import SwiftUI

struct Navbar: View {
    var festival: Festival

    var body: some View {
            VStack {
                NavigationLink(destination: ListeJeuView()) {
                    Text("Jeux")
                }
                NavigationLink(destination: ListePosteView(festival: festival)) {
                    Text("Postes")
                }
                NavigationLink(destination: ListeInscriptionView()) {
                    Text("Inscription")
                }
            }
        }
}
