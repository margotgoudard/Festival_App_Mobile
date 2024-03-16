import SwiftUI

struct ListePosteView: View {
    @ObservedObject private var viewModel: PosteViewModel
    var festival: Festival
    @State private var selectedPoste: Poste?
    
    init(festival: Festival){
        self.festival = festival
        viewModel = PosteViewModel()
    }

    var body: some View {
        NavigationView {
            VStack {
                if(festival.valide){
                    List(viewModel.postes) { poste in
                        Button(action: {
                            self.selectedPoste = poste
                        }) {
                            Text(poste.nom)
                        }
                    }
                } else {
                    VStack{
                        Text("PAS OUVERT")
                    }.onAppear{
                        print("test")
                    }
                }
            }
            .onAppear {
                viewModel.fetchPostes(forFestivalId: festival.id)
            }
            .sheet(item: $selectedPoste) { poste in
                PosteDetailView(poste: poste, festival: festival)
            }
        }
        .navigationBarTitle("Liste des postes", displayMode: .inline)
    }
}
