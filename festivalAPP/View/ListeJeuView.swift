import SwiftUI

struct ListeJeuView: View {
    @ObservedObject private var viewModel: JeuViewModel
    var festival: Festival
    // Ajouter un @State pour gérer l'espace sélectionné
    @State private var selectedEspace: Espace?

    init(festival: Festival, viewModel: JeuViewModel) {
        self.festival = festival
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if festival.valide {
                List(viewModel.espaces, id: \.id) { espace in
                    Button(espace.nom) {
                        self.selectedEspace = espace
                    }
                }
                .sheet(item: $selectedEspace) { espace in
                    EspaceDetailView(espace: espace, jeux: viewModel.jeuxByZone[espace.id] ?? [])
                }
            } else {
                VStack {
                    Text("PAS OUVERT")
                }.onAppear {
                    print("test")
                }
            }
        }
        .onAppear {
            viewModel.fetchEspaces(forFestivalId: festival.id)
        }
        .navigationBarTitle("Liste des jeux", displayMode: .inline)
    }
}
