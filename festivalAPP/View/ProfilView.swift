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
               Menu {
                   ForEach(festivalUtils.festivals) { festival in
                       Button(festival.nom) {
                           selectedFestivalForDetails = festival
                           dropdownTitle = festival.nom
                       }
                   }
               } label: {
                   HStack {
                       Text(dropdownTitle)
                           .foregroundColor(.blue) // Changez ici pour la couleur de texte désirée
                       Image(systemName: "chevron.down") // Chevron vers le bas
                   }
                   .padding()
                   .frame(maxWidth: .infinity)
                   .cornerRadius(10)
               }
               .padding(.horizontal)

               if let festivalToDisplay = selectedFestivalForDetails {
                   NavigationLink(destination: Navbar(festival: festivalToDisplay), isActive: .constant(true)) { EmptyView() }
               }

               VStack {
                   InitialsCircleView(initials: "\(user.prenom.prefix(1))\(user.nom.prefix(1))")
                                  .frame(maxWidth: .infinity)
                                  .background(Color(UIColor.systemGroupedBackground))
                                  .padding(.top, 20)
                        
               List {
                  
                   Section(header: Text("Informations Personnelles")) {
                   ProfileTextField(label: "Nom", text: $user.nom)
                   ProfileTextField(label: "Prénom", text: $user.prenom)
                   ProfileTextField(label: "Pseudo", text: $user.pseudo)
                   ProfileTextField(label: "Email", text: $user.mail)
                   ProfileTextField(label: "Téléphone", text: $user.tel)
                   }
                   
                   Section(header: Text("Préférences")) {

                   Toggle(isOn: Binding<Bool>(
                       get: { self.user.est_vegetarien ?? false },
                       set: { self.user.est_vegetarien = $0 }
                   )) {
                       Text(user.est_vegetarien ?? false ? "Végétarien" : "Non Végétarien")
                   }
                   ProfileTextField(label: "Taille de T-Shirt", text: $user.taille_tshirt)
                   }
                   Section(header: Text("Autres Informations")) {

                   ProfileTextFieldOptional(label: "Association", text: $user.association)
                   ProfileTextFieldOptional(label: "Jeu préféré", text: $user.jeu_prefere)
                   ProfileTextFieldOptional(label: "Hébergement", text: $user.hebergement)
                   }
               }.padding(.top, 0)
                   
               }
               .background(Color(UIColor.systemGroupedBackground))
               .onAppear {
                   dropdownTitle = "Sélectionnez un festival"
                   selectedFestivalForDetails = nil
               }
               
               Button(action: {
                   updateUserInfo(user)
               }) {
                   Text("Enregistrer les modifications")
                       .padding()
                       .foregroundColor(.blue)
                       .background(Color.white)
                       .cornerRadius(10)
               }
               
               NavigationLink(destination: ContentView(), isActive: $estDeconnecte) {
                               Button("Déconnexion") {
                                   deconnexion()
                               }
                               .padding()
                               .foregroundColor(.red)
                               .background(Color.white)
                               .cornerRadius(10)
                           }
                       }
                       .navigationBarBackButtonHidden(true)
       }
}
    
struct ProfileTextField: View {
    var label: String
    @Binding var text: String

    var body: some View {
        HStack {
            Text("\(label):")
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
            Text("\(label):")
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

struct InitialsCircleView: View {
    var initials: String
    
    var body: some View {
        Text(initials)
            .foregroundColor(.white)
            .padding()
            .background(Circle().fill(Color.blue))
            .font(.title)
    }
}
