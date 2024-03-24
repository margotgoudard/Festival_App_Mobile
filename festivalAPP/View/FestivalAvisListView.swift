import SwiftUI

struct FestivalAvisListView: View {
    var festival: Festival
    @ObservedObject var avisViewModel: AvisViewModel
    let idUser: Int
    @Binding var idAvisEnEdition: Int?
    @Binding var texteAvisEnEdition: String
    
    var body: some View {
        VStack {
            Text("Avis des bénévoles :")
                .font(.headline)
                .padding(.top, 5)
            
            if avisViewModel.avis.isEmpty {
                Text("Aucun avis")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(avisViewModel.avis) { avis in
                    if idAvisEnEdition == avis.id {
                        AvisEditorView(texteAvisEnEdition: $texteAvisEnEdition, onValider: {
                            avisViewModel.updateAvis(idavis: avis.id, texte: texteAvisEnEdition, date: Date(), idfestival : festival.id)
                            idAvisEnEdition = nil
                        }, onAnnuler: {
                            idAvisEnEdition = nil
                        })
                    } else {
                        AvisDisplayView(avis: avis, idUser: idUser, onEdit: {
                            idAvisEnEdition = avis.id
                            texteAvisEnEdition = avis.texte

                        }, onDelete: {
                            avisViewModel.deleteAvis(idavis: avis.id, idfestival: festival.id)
                        })
                    }
                }
            }
        }
        .padding()
        .onAppear {
            avisViewModel.fetchAvis(forFestivalId: festival.id)
        }
        .navigationTitle("Détails du festival")
        .navigationBarTitleDisplayMode(.inline)
    }
}
