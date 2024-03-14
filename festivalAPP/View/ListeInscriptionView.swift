import SwiftUI

struct ListeInscriptionView: View {
    @ObservedObject var viewModel = InscriptionViewModel()
    @ObservedObject var festivalUtils = FestivalUtils()
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    let idUser = UserDefaults.standard.integer(forKey: "iduser")
    
    var body: some View {
        VStack {
            
            
            if viewModel.isLoading {
                        ProgressView()
                    } else if !viewModel.groupedInscriptionsByDayAndTime.isEmpty {
                        List {
                            ForEach(Array(viewModel.groupedInscriptionsByDayAndTime.keys.sorted()), id: \.self) { day in
                                Section(header: Text(day)) {
                                    ForEach(Array(viewModel.groupedInscriptionsByDayAndTime[day]!.keys.sorted()), id: \.self) { time in
                                        Section(header: Text(time)) {
                                            ForEach(viewModel.groupedInscriptionsByDayAndTime[day]![time]!) { inscription in
                                                VStack(alignment: .leading) {
                                                    Text("Poste: \(inscription.poste.nom)")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        Text("Aucune inscription trouvée")
                    }
            
            if !viewModel.notification.isEmpty {
                Text(viewModel.notification)
                    .foregroundColor(.red)
            }
        }
    }
}
