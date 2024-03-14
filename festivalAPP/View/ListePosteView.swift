import SwiftUI

struct ListePosteView: View {
    @ObservedObject private var viewModel: PosteViewModel
     var festival: Festival
    
    init(festival: Festival){
        self.festival = festival
        viewModel = PosteViewModel()
        print(festival.valide)
    }

    var body: some View {
        ScrollView {
        NavigationView {
            VStack {
                if(festival.valide){
                    List(viewModel.postes) { poste in
                        NavigationLink(destination: PosteDetailView(poste: poste)) {
                            Text(poste.nom)
                        }
                    }
                    .navigationTitle("Postes")
                }else{
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

    
            .navigationTitle("Festivals et Postes")
        }
        }
    }
    
}
