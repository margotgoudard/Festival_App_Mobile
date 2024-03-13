import SwiftUI

struct ProfilView: View {
   @State var user: User
   @State private var isMenuVisible = false
    
    var body: some View {
        HStack {
                            Button(action: {
                                isMenuVisible.toggle()
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                        .padding()
                                    
                        if isMenuVisible {
                            Navbar()
                        }
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Profil").font(.largeTitle).fontWeight(.bold)
                
                HStack {
                    Text("Nom:").bold()
                    Spacer()
                    TextField("Nom", text: $user.nom)
                }
                
                HStack {
                    Text("Prénom:").bold()
                    Spacer()
                    TextField("Prénom", text: $user.prenom)
                }
                
                HStack {
                    Text("Pseudo:").bold()
                    Spacer()
                    TextField("Pseudo", text: $user.pseudo)
                }
                
            }
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Text("Email:").bold()
                    Spacer()
                    TextField("Mail", text: $user.mail)
                }
                
                HStack {
                    Text("Téléphone:").bold()
                    Spacer()
                    TextField("Téléphone", text: $user.tel)
                }
                
                HStack {
                    Text("Association:").bold()
                    Spacer()
                    TextField("Association", text: $user.association)
                }
                
                HStack {
                    Text("Jeu préféré:").bold()
                    Spacer()
                    TextField("Jeu Préféré", text: $user.jeu_prefere)
                }
                
                HStack {
                    Text("Taille de T-Shirt:").bold()
                    Spacer()
                    TextField("Taille", text: $user.taille_tshirt)
                }
                
                HStack {
                    Text("Hébergement:").bold()
                    Spacer()
                    TextField("Hébergement", text: $user.hebergement)
                }
                
                
                HStack {
                    Text("Végétarien:").bold()
                    Spacer()
                    Toggle(isOn: $user.est_vegetarien) {
                            Text(user.est_vegetarien ? "Oui" : "Non")
                    }
                }
                Button(action: {
                    let updatedUser = User(association: user.association, est_vegetarien: user.est_vegetarien,  hebergement: user.hebergement, iduser: user.iduser, jeu_prefere: user.jeu_prefere, mail: user.mail, mdp: user.mdp, nom: user.nom, prenom: user.prenom, pseudo: user.pseudo, taille_tshirt: user.taille_tshirt, tel: user.tel)

                    updateUserInfo(updatedUser)
                            }) {
                                Text("Enregistrer les modifications")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }

            }
            .padding()
        }
    }
}

func updateUserInfo(_ updatedUser: User) {
    guard let jsonData = try? JSONEncoder().encode(updatedUser) else {
        print("Erreur lors de l'encodage des données utilisateur en JSON")
        return
    }
    
    let urlString = "https://benevole-app-back.onrender.com/user/update-user"
    guard let url = URL(string: urlString) else {
        print("URL invalide")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
        request.httpBody = jsonData
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Erreur lors de la requête HTTP: \(error)")
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("Code de statut HTTP de la réponse: \(httpResponse.statusCode)")
        }
    }
    
    task.resume()
}
