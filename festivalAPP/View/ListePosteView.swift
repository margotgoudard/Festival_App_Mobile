import SwiftUI

struct ListePosteView: View {
    @ObservedObject private var viewModel: PosteViewModel
    @ObservedObject private var festivalUtils: FestivalUtils
    init(){
        viewModel = PosteViewModel()
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
                    viewModel.fetchPostes(forFestivalId: newValue)
                    festivalUtils.setSelectedFestival()
                }
                
                if(festivalUtils.selectedFestival!.valide){
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
                        print("test",festivalUtils.selectedFestival!)
                    }
                    
                }
            
            }
            .onAppear {
                viewModel.fetchPostes(forFestivalId: festivalUtils.selectedFestivalId)
            }
    
            .navigationTitle("Festivals et Postes")
        }
        }
    }
    
}
