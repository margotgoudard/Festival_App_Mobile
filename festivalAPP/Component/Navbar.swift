import SwiftUI

struct Navbar: View {
    var body: some View {
            VStack {
                NavigationLink(destination: ListeJeuView()) {
                    Text("Jeux")
                }
                NavigationLink(destination: ListePosteView()) {
                    Text("Postes")
                }
                NavigationLink(destination: ListeInscriptionView()) {
                    Text("Inscription")
                }
            }
        }
}
