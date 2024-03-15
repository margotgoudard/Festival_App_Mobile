import SwiftUI

struct InscrireView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var user = User(association: "", est_vegetarien: false, hebergement: "", iduser: 0, jeu_prefere: "", mail: "", mdp: "", nom: "", prenom: "", pseudo: "", taille_tshirt: "", tel: "")
    @State private var showAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Informations personnelles")) {
                TextField("Nom", text: $user.nom)
                TextField("Prénom", text: $user.prenom)
                TextField("E-mail", text: $user.mail)
                SecureField("Mot de passe", text: $user.mdp)
                TextField("Téléphone", text: $user.tel)
                TextField("Pseudo", text: $user.pseudo)
                Toggle("Est végétarien ?", isOn: $user.est_vegetarien)
            }
            
            Section(header: Text("Détails supplémentaires")) {
                TextField("Association", text: $user.association)
                TextField("Hébergement", text: $user.hebergement)
                TextField("Jeu préféré", text: $user.jeu_prefere)
                TextField("Taille T-shirt", text: $user.taille_tshirt)
            }
            
            Button("S'inscrire") {
                registerUser()
            }
        }
        .navigationBarTitle("Inscription", displayMode: .inline)
        .alert("Inscription réussie", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
    }
    
    func registerUser() {
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
