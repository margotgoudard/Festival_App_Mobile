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
                
                Picker("Sélectionnez un festival", selection: $festivalUtils.selectedFestivalId) {
                    ForEach(festivalUtils.festivals) { festival in
                        Text(festival.nom).tag(festival.idfestival as Int?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: festivalUtils.selectedFestivalId) { newValue in
                    viewModel.fetchEspaces(forFestivalId: newValue)
                    festivalUtils.setSelectedFestival()
                }
                
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
                viewModel.fetchEspaces(forFestivalId: festivalUtils.selectedFestivalId)
            }
    
            .navigationTitle("Festivals et Postes")
        }
        }
    }
    
}
