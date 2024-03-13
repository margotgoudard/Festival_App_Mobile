import SwiftUI

struct ListePosteView: View {
    @StateObject private var viewModel = PosteViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Picker("Sélectionnez un festival", selection: $viewModel.selectedFestivalId) {
                    ForEach(viewModel.festivals) { festival in
                        Text(festival.nom).tag(festival.idfestival as Int?)
                    }
                }
                .onAppear {
                    viewModel.fetchFestivals()
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewModel.selectedFestivalId) { newValue in
                    if let festivalId = newValue {
                        viewModel.fetchPostes(forFestivalId: festivalId)
                    }
                }

                List(viewModel.postes) { poste in
                    Text(poste.nom)
                }
            }
            .navigationTitle("Festivals et Postes")
        }
    }
    
}
