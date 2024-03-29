import SwiftUI

struct InscrireView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var user = User(association: nil, est_vegetarien: false, hebergement: "", iduser: 0, jeu_prefere: "", mail: "", mdp: "", nom: "", prenom: "", pseudo: "", taille_tshirt: "", tel: "")
    @State private var showAlert = false
    @State private var association: String = ""
    @State private var est_vegetarien: Bool = false
    @State private var hebergement: String = ""
    @State private var jeu_prefere: String = ""



    var body: some View {
        Text("Inscription")
            .font(.title)
            .fontWeight(.bold)
            .padding(.bottom, 20)
        Form {
            Section(header: Text("Informations personnelles")) {
                TextField("Nom", text: $user.nom)
                TextField("Prénom", text: $user.prenom)
                TextField("E-mail", text: $user.mail)
                SecureField("Mot de passe", text: $user.mdp)
                TextField("Téléphone", text: $user.tel)
                TextField("Pseudo", text: $user.pseudo)
                Toggle("Est végétarien ?", isOn: $est_vegetarien)
            }
            
            Section(header: Text("Détails supplémentaires")) {
                TextField("Association", text: $association)
                TextField("Hébergement", text: $hebergement)
                TextField("Jeu préféré", text: $jeu_prefere)
                TextField("Taille T-shirt", text: $user.taille_tshirt)
            }
        }.background(Color.white)
        .scrollContentBackground(.hidden)
        .alert("Inscription réussie", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
        Button("S'inscrire") {
            registerUser()
        }.buttonStyle(PrimaryButtonStyle())
            .padding(.bottom, 20)
    }
    
    func registerUser() {
        
        user.association = association.isEmpty ? nil : association
        user.hebergement = hebergement.isEmpty ? nil : hebergement
        user.jeu_prefere = jeu_prefere.isEmpty ? nil : jeu_prefere
        user.est_vegetarien = est_vegetarien


        guard let url = URL(string: "https://benevole-app-back.onrender.com/user/inscription") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(user)
        } catch {
            print("Failed to encode user: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Handle networking error
                    print("Networking error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    // Handle server-side error
                    print("Server error or invalid response")
                    return
                }
                
                self.showAlert = true
                print("User registered successfully")
                // Optionally reset the form or navigate away
                self.presentationMode.wrappedValue.dismiss()
            }
        }.resume()
}
}
