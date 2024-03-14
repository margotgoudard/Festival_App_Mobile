import SwiftUI

struct ListeJeuView: View {
    @ObservedObject private var viewModel: JeuViewModel
    var festival: Festival
   
   init(festival: Festival){
       self.festival = festival
       viewModel = JeuViewModel()
   }

    var body: some View {
        ScrollView {
        NavigationView {
            VStack {
                
                if(festival.valide){
                    List(viewModel.espaces, id: \.id) { espace in
                        NavigationLink(destination: EspaceDetailView(espace: espace, jeux: viewModel.jeuxByZone[espace.id] ?? [])) {
                            Text(espace.nom)
                        }
                    }
                    .navigationTitle("Espaces")
                }else{
                    VStack{
                        Text("PAS OUVERT")
                    }.onAppear{
                        print("test")
                    }
                    
                }
            
            }
            .onAppear {
                viewModel.fetchEspaces(forFestivalId: festival.id)
            }
    
            .navigationTitle("Festivals et Postes")
        }
        }
    }
    
}
