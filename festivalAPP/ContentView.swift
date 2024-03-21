import SwiftUI

struct ContentView: View {
    @State private var isRegistering = false
    @State private var isLoggingIn = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image(uiImage: UIImage(named: "logo.png")!) // Assure-toi que l'image existe
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("Festival du Jeu de Montpellier")
                    .font(.title)
                    .padding(.bottom, 20)
                
                Button("Rejoignez-nous dès maintenant") {
                    isRegistering = true
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.bottom, 10)
                
                NavigationLink(destination: InscrireView(), isActive: $isRegistering) { EmptyView() }

                Spacer()
            }
            .navigationBarItems(trailing: Button(action: {
                isLoggingIn = true
            }) {
                Text("Se connecter")
            })
            .fullScreenCover(isPresented: $isLoggingIn) {
                LoginView() // Ici, tu insères ta vue de connexion
            }
        }
        .navigationBarHidden(true) // Masque toute la barre de navigation
        .navigationBarBackButtonHidden(true) // Masque spécifiquement le bouton de retour
    }
}
