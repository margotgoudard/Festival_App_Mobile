import SwiftUI

// Assuming User and Festival models are defined elsewhere
struct ProfilView: View {
    @State private var user: User
    @ObservedObject private var festivalUtils: FestivalUtils
    @State private var selectedFestivalForDetails: Festival?
    @State private var dropdownTitle = "Sélectionnez un festival"
    @State private var estDeconnecte = false

    
    init(festivalUtils: FestivalUtils, user: User) {
        self._festivalUtils = ObservedObject(initialValue: festivalUtils)
        self._user = State(initialValue: user)
    }

    func deconnexion() {
        UserDefaults.standard.set("", forKey: "token")
        estDeconnecte = true
    }
    
    var body: some View {
        VStack {
            HStack {
                Menu(dropdownTitle) {
                    ForEach(festivalUtils.festivals) { festival in
                        
                        Button("\(festival.nom)") {
                            selectedFestivalForDetails = festival
                            dropdownTitle = "\(festival.nom)"
                        }
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)

                if let festivalToDisplay = selectedFestivalForDetails {
                    NavigationLink(destination: FestivalView(festival: festivalToDisplay), isActive: .constant(true)) { EmptyView() }
                }
                
                Spacer()
                
                Button("deconnexion") {
                    deconnexion()
                }
                NavigationLink(destination: ContentView(), isActive: $estDeconnecte) { EmptyView() }
            }
            .padding()
            
            
            profileForm
        }
        .onAppear {
            dropdownTitle = "Sélectionnez un festival"
            selectedFestivalForDetails = nil
        } .navigationBarBackButtonHidden(true)
    }

    
    private var profileForm: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Profil").font(.largeTitle).fontWeight(.bold)
                
                Group {
                    ProfileTextField(label: "Nom", text: $user.nom)
                    ProfileTextField(label: "Prénom", text: $user.prenom)
                    ProfileTextField(label: "Pseudo", text: $user.pseudo)
                    ProfileTextField(label: "Email", text: $user.mail)
                    ProfileTextField(label: "Téléphone", text: $user.tel)
                    ProfileTextFieldOptional(label: "Association", text: $user.association)
                    ProfileTextFieldOptional(label: "Jeu préféré", text: $user.jeu_prefere)
                    ProfileTextField(label: "Taille de T-Shirt", text: $user.taille_tshirt)
                    ProfileTextFieldOptional(label: "Hébergement", text: $user.hebergement)
                }
                
                Toggle(isOn: Binding<Bool>(
                    get: { self.user.est_vegetarien ?? false },
                    set: { self.user.est_vegetarien = $0 }
                )) {
                    Text(user.est_vegetarien ?? false ? "Végétarien" : "Non Végétarien").bold()
                }

                
                Button(action: {
                    updateUserInfo(user)
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
    
struct ProfileTextField: View {
    var label: String
    @Binding var text: String

    var body: some View {
        HStack {
            Text("\(label):").bold()
            Spacer()
            TextField(label, text: $text)
        }
    }
}

struct ProfileTextFieldOptional: View {
    var label: String
    @Binding var text: String?

    var body: some View {
        HStack {
            Text("\(label):").bold()
            Spacer()
            TextField(label, text: Binding<String>(
                get: { self.text ?? "" },
                set: { newValue in self.text = newValue.isEmpty ? nil : newValue }
            ))
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
}
