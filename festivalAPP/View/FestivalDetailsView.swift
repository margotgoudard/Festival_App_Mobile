import SwiftUI

struct FestivalDetailsView: View {
    var festival: Festival
    @State private var avis: String = ""
    @ObservedObject var avisViewModel: AvisViewModel
    let idUser = UserDefaults.standard.integer(forKey: "iduser")
    
    @State private var idAvisEnEdition: Int?
    @State private var texteAvisEnEdition: String = ""
    
    init(festival: Festival) {
        self.festival = festival
        avisViewModel = AvisViewModel(idfestival: festival.id)
    }
    
    var body: some View {
        ScrollView {
            FestivalDetailsHeaderView(festival: festival)
            
            Divider()
            
            if (festival.valide ){
            
            FestivalAvisEditorView(avis: $avis) {
                avisViewModel.ajouterAvis(texte: avis, idfestival: festival.id, iduser: idUser, date: Date())
                avis = ""
            }
            
            FestivalAvisListView(festival: festival, avisViewModel: avisViewModel, idUser: idUser, idAvisEnEdition: $idAvisEnEdition, texteAvisEnEdition: $texteAvisEnEdition)
        } else {
            VStack {
                Text("PAS OUVERT")
            }.onAppear {
                print("test")
            }
        }
        }
        .onAppear {
            avisViewModel.fetchAvis(forFestivalId: festival.id)
        }
        .navigationTitle("Détails du festival")
        .navigationBarTitleDisplayMode(.inline)
    }
}




                
