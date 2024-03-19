import SwiftUI

struct LoginView: View {
    
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
                    .padding(.horizontal, 30)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                
                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 30)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                
                if !notification.isEmpty {
                    Text(notification)
                        .foregroundColor(.red)
                }
                
                Button("Se connecter") {
                    login()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                let festivalUtils = FestivalUtils()
                
                if let user = userData {
                    NavigationLink(destination: ProfilView(festivalUtils: festivalUtils, user: user), isActive:.constant(true)) { EmptyView() }
                }
                Button("S'inscrire") {
                    inscrire()
                }
                
                NavigationLink(destination: InscrireView(), isActive: $isRegistering) { EmptyView() }
                .buttonStyle(PrimaryButtonStyle())
            }
        }.navigationBarBackButtonHidden(true)

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
        
        print("Envoi de la requête")
        
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
                        // Supposons que loginResponse.user contient un objet User avec toutes les infos
                        let user = loginResponse.user
                        UserDefaults.standard.set(loginResponse.token, forKey: "token")
                        UserDefaults.standard.set(user?.iduser, forKey: "iduser")
                        // Enregistrer chaque propriété individuellement
                        UserDefaults.standard.set(user?.association, forKey: "association")
                        UserDefaults.standard.set(user?.est_vegetarien, forKey: "est_vegetarien")
                        UserDefaults.standard.set(user?.hebergement, forKey: "hebergement")
                        UserDefaults.standard.set(user?.jeu_prefere, forKey: "jeu_prefere")
                        UserDefaults.standard.set(user?.mail, forKey: "mail")
                        UserDefaults.standard.set(user?.mdp, forKey: "mdp") // Faites attention à stocker des mots de passe en clair
                        UserDefaults.standard.set(user?.nom, forKey: "nom")
                        UserDefaults.standard.set(user?.prenom, forKey: "prenom")
                        UserDefaults.standard.set(user?.pseudo, forKey: "pseudo")
                        UserDefaults.standard.set(user?.taille_tshirt, forKey: "taille_tshirt")
                        UserDefaults.standard.set(user?.tel, forKey: "tel")

                        userData = user
                        isAuthenticated = true
                        print("Connexion réussie")

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

