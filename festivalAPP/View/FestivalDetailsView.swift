import SwiftUI

struct FestivalDetailsView: View {
    var festival: Festival
    @State private var avis: String = ""
    @ObservedObject var avisViewModel: AvisViewModel
    let idUser = UserDefaults.standard.integer(forKey: "iduser")

    init(festival: Festival){
        self.festival = festival
        avisViewModel = AvisViewModel()
    }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(festival.nom)
                    .font(.largeTitle)
                    .padding(.bottom, 2)
                
                Text("Dates : \(festival.date_debut?.formatted(date: .abbreviated, time: .omitted) ?? "N/A") - \(festival.date_fin?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
                    .font(.body)


                
                Text("Comment y venir en tram :")
                    .font(.headline)
                    .padding(.top, 5)
                
                
                    Text("Informations supplémentaires :")
                        .font(.headline)
                        .padding(.top, 5)
                
            
                
                Divider()
                
                Text("Laissez un avis sur le festival :")
                    .font(.headline)
                    .padding(.top, 5)
                
                TextEditor(text: $avis)
                    .frame(height: 100)
                    .border(Color.gray, width: 1)
                    .padding(.bottom, 5)
                
                Button("Soumettre l'avis") {

                    
                    avisViewModel.ajouterAvis(texte: avis, idfestival: festival.id, iduser: idUser, date: Date())
                    avis = ""
                }
                .buttonStyle(.bordered)
                .padding(.bottom, 5)
                
                Divider()
                
                Text("Avis des bénévoles :")
                    .font(.headline)
                    .padding(.top, 5)
            }
            .padding()
            List(avisViewModel.avis, id: \.id) { avis in
                            VStack(alignment: .leading) {
                                Text(avis.texte)
                                    .font(.headline)
                                Text("User: \(avis.iduser) - Festival: \(avis.idfestival)")
                                    .font(.subheadline)
                            
                            }

        }
        .onAppear {
            avisViewModel.fetchAvis(forFestivalId: festival.id)

        }
        .navigationTitle("Détails du festival")
        .navigationBarTitleDisplayMode(.inline)
    }
}

