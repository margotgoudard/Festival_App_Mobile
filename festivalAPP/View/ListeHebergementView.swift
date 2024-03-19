import SwiftUI

struct ListeHebergementView: View {
    @ObservedObject private var viewModel: HebergementViewModel
    var festival: Festival
    var userId: Int = UserDefaults.standard.integer(forKey: "iduser")
    @State private var showingCreateHebergement = false


    init(festival: Festival){
        self.festival = festival
        viewModel = HebergementViewModel()
    }

    var body: some View {
        NavigationView {
            VStack {
                if festival.valide {
                    List(viewModel.hebergements) { hebergement in
                        Text(hebergement.User.nom)
                    }
                    Text("Mes hébergements")
                        .font(.headline)
                    List(viewModel.userhebergements) { hebergement in
                        Text(hebergement.description)
                    }
                } else {
                    Text("PAS OUVERT")
                }
            }
            .navigationBarTitle("Liste des hébergements", displayMode: .inline)
                        .navigationBarItems(trailing: Button(action: {
                            showingCreateHebergement = true
                        }) {
                            Text("Créer")
                        })
                        .sheet(isPresented: $showingCreateHebergement) { 
                            CreateHebergementView(idfestival: festival.id)
                        }
                        .onAppear {
                            viewModel.fetchHebergements(forFestivalId: festival.id)
                            viewModel.fetchHebergementsByUser(userId: userId, idfestival: festival.id)
                        }
        }
    }
}
