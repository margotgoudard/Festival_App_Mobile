import SwiftUI

struct ContentView: View {
    
    @State private var mail: String = ""
    @State private var password: String = ""
    @State private var notification: String = ""
    @State private var isAuthenticated = false
    @State private var isRegistering = false
    @State private var userData: User?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
        
                TextField("Email", text: $mail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !notification.isEmpty {
                    Text(notification)
                        .foregroundColor(.red)
                }
                
                Button("Se connecter") {
                    login()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                if let user = userData {
                    NavigationLink(destination: ProfilView(user: user), isActive:.constant(true)) { EmptyView() }
                }
                Button("S'inscrire") {
                    inscrire()
                }
                
                NavigationLink(destination: InscrireView(), isActive: $isRegistering) { EmptyView() }
                .buttonStyle(PrimaryButtonStyle())
            }
                .onTapGesture {
                    isAuthenticated = false
                    userData = nil
                }
                .onAppear {
                    mail = ""
                    password = ""
                }

        }
    }
    
    
    func inscrire() {
        isRegistering = true
    }

    
    func login() {
        print("Début de la méthode login")
        
        guard !mail.isEmpty, !password.isEmpty else {
            notification = "Veuillez remplir tous les champs."
            print("Email ou mot de passe vide")
            return
        }
        
        guard let url = URL(string: "https://benevole-app-back.onrender.com/user/connexion") else {
            print("L'URL est invalide")
            return
        }
        
        let body: [String: String] = ["mail": mail, "mdp": password]
        guard let finalBody = try? JSONEncoder().encode(body) else {
            print("Échec de l'encodage du body")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Envoi de la ...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    notification = "Network request failed"
                    print("Échec de la requête réseau : \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    notification = "Aucune donnée reçue"
                    print("Aucune donnée reçue du serveur")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Réponse du serveur : \(httpResponse.statusCode)")
                }
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    if loginResponse.auth {
                        UserDefaults.standard.set(loginResponse.token, forKey: "token")
                        userData = loginResponse.user // Stocker les données utilisateur
                        isAuthenticated = true // Navigate to the next view
                        self.userData = loginResponse.user
                        print("Connexion réussie")
                        print(loginResponse.user)
                    } else {
                        notification = "Login failed"
                        print("Échec de la connexion : auth = false")
                    }
                } catch {
                    notification = "Login failed"
                    print("Erreur de décodage : \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}



struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
