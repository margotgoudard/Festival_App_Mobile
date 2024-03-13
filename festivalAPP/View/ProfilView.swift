import SwiftUI

struct ProfilView: View {
    var user: User
    
    var body: some View {
        NavigationView {
            Menu {
                NavigationLink(destination: ListeJeuView()) {
                    Text("Jeux")
                }
                NavigationLink(destination: ListePosteView()) {
                    Text("Postes")
                }
                NavigationLink(destination: ListeInscriptionView()) {
                    Text("Inscription")
                }
            } label: {
                Label("Menu", systemImage: "line.horizontal.3")
            }
        }
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Profil").font(.largeTitle).fontWeight(.bold)
                
                HStack {
                    Text("Nom:").bold()
                    Spacer()
                    Text(user.nom)
                }
                
                HStack {
                    Text("Prénom:").bold()
                    Spacer()
                    Text(user.prenom)
                }
                
                HStack {
                    Text("Pseudo:").bold()
                    Spacer()
                    Text(user.pseudo)
                }
                
            }
            VStack(alignment: .leading, spacing: 20) {
                
                
                HStack {
                    Text("Email:").bold()
                    Spacer()
                    Text(user.mail)
                }
                
                HStack {
                    Text("Téléphone:").bold()
                    Spacer()
                    Text(user.tel)
                }
                
                HStack {
                    Text("Association:").bold()
                    Spacer()
                    Text(user.association)
                }
                
                HStack {
                    Text("Jeu préféré:").bold()
                    Spacer()
                    Text(user.jeu_prefere)
                }
                
                HStack {
                    Text("Taille de T-Shirt:").bold()
                    Spacer()
                    Text(user.taille_tshirt)
                }
                
                HStack {
                    Text("Hébergement:").bold()
                    Spacer()
                    Text(user.hebergement)
                }
                
                
                HStack {
                    Text("Végétarien:").bold()
                    Spacer()
                    Text(user.est_vegetarien ? "Oui" : "Non")
                }

            }
            .padding()
        }
    }
}
