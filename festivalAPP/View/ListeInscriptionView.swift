import SwiftUI

struct ListeInscriptionView: View {
    @ObservedObject var viewModel: InscriptionViewModel
    var festival: Festival
   
   init(festival: Festival){
       self.festival = festival
       viewModel = InscriptionViewModel()
   }
    
    var body: some View {
        VStack {
            if festival.valide {
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
            } else {
                Text("Le festival n'est pas ouvert aux inscriptions")
            }
            
            if !viewModel.notification.isEmpty {
                Text(viewModel.notification)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            let iduser = UserDefaults.standard.integer(forKey: "iduser")
            viewModel.fetchInscriptions(idUser: iduser, idFestival: festival.id)
        }
    }
}
