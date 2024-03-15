import SwiftUI

struct ListeJeuView: View {
    @ObservedObject private var viewModel: JeuViewModel
    var festival: Festival
   
    init(festival: Festival, viewModel : JeuViewModel){
       self.festival = festival
        self.viewModel = viewModel
   }

    var body: some View {
        NavigationView {
            VStack {
                
                if(festival.valide){
                    List(viewModel.espaces, id: \.id) { espace in
                        NavigationLink(destination: EspaceDetailView(espace: espace, jeux: viewModel.jeuxByZone[espace.id] ?? [])) {
                            Text(espace.nom)
                        }
                    }
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
            
    
        }.navigationBarTitle("Liste des jeux", displayMode: .inline)
    }
    
}
