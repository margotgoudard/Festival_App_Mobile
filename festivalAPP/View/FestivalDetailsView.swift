import SwiftUI

struct FestivalDetailsView: View {
    var festival: Festival
    @State private var avis: String = ""
    @ObservedObject var avisViewModel: AvisViewModel
    let idUser = UserDefaults.standard.integer(forKey: "iduser")

    init(festival: Festival) {
        self.festival = festival
        avisViewModel = AvisViewModel(idfestival: festival.id)
    }
    
    var body: some View {
        ScrollView {
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
                
                
                Text("Avis des bénévoles :")
                    .font(.headline)
                    .padding(.top, 5)
                

                if avisViewModel.avis.isEmpty {
                    Text("Aucun avis")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(avisViewModel.avis) { avis in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(avis.texte)
                                .font(.headline)
                            
                            Text("Posté par l'utilisateur \(avis.iduser) le \(avis.date)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(10)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
            
        }
        .onAppear {
            avisViewModel.fetchAvis(forFestivalId: festival.id)
        }
        .navigationTitle("Détails du festival")
        .navigationBarTitleDisplayMode(.inline)
    }
}

