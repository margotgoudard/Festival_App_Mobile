import SwiftUI

struct ListeJeuView: View {
    @ObservedObject private var viewModel: JeuViewModel
    @ObservedObject private var festivalUtils: FestivalUtils
    init(){
        viewModel = JeuViewModel()
        festivalUtils = FestivalUtils()
    }

    var body: some View {
        ScrollView {
        NavigationView {
            VStack {
                
                if(festivalUtils.selectedFestival!.valide){
                    List(viewModel.espaces) { espace in
                        NavigationLink(destination: EspaceDetailView(espace: espace, jeux: viewModel.jeuxByZone[espace.idzonebenevole]!)) {
                            Text(espace.nom)
                        }
                    }
                    .navigationTitle("Espaces")
                }else{
                    VStack{
                        Text("PAS OUVERT")
                    }.onAppear{
                        print("test",festivalUtils.selectedFestival!)
                    }
                    
                }
            
            }
            .onAppear {
                if let festivalId = festivalUtils.selectedFestivalId {
                                        viewModel.fetchEspaces(forFestivalId: festivalId)
                                    }
            }
    
            .navigationTitle("Festivals et Postes")
        }
        }
    }
    
}
