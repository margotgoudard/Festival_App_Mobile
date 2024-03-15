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
        NavigationView {
            VStack {
                if(festival.valide){
                    List(viewModel.postes) { poste in
                        NavigationLink(destination: PosteDetailView(poste: poste)) {
                            Text(poste.nom)
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
                viewModel.fetchPostes(forFestivalId: festival.id)
            }

    
            
        }
        
        .navigationBarTitle("Liste des postes", displayMode: .inline)
        
    }
    
}
