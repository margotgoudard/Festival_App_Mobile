import SwiftUI

struct CreateHebergementView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var nbPlaces: String = ""
    @State private var distance: String = ""
    @State private var description: String = ""
    var idfestival: Int
    
    @ObservedObject var viewModel: HebergementViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations de l'hébergement")) {
                    TextField("Nombre de places", text: $nbPlaces)
                        .keyboardType(.numberPad)
                    TextField("Distance (en mètres)", text: $distance)
                        .keyboardType(.numberPad)
                    TextField("Description", text: $description)
                }
                
                Button(action: {
                    // Your button action for creating hebergement
                    if let nbPlacesInt = Int(nbPlaces), let distanceInt = Int(distance) {
                        let user = User(iduser: UserDefaults.standard.integer(forKey: "iduser"), mail: UserDefaults.standard.string(forKey: "mail")!, mdp: UserDefaults.standard.string(forKey: "mdp")!, nom: UserDefaults.standard.string(forKey: "nom")!, prenom: UserDefaults.standard.string(forKey: "prenom")!, pseudo: UserDefaults.standard.string(forKey: "pseudo")!, taille_tshirt: UserDefaults.standard.string(forKey: "taille_tshirt")!, tel: UserDefaults.standard.string(forKey: "tel")!)
                        let newHebergement = Hebergement(id: 0, nb_places: nbPlacesInt, distance: distanceInt, user: user, idfestival: idfestival, description: description)
                        viewModel.createHebergement(hebergement: newHebergement)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Créer l'hébergement")
                }
                
                Button("Annuler") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle("Nouvel héébergement", displayMode: .inline)

        }
    }
}
