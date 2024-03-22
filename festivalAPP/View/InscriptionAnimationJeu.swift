import SwiftUI
struct InscriptionAnimationJeu: View {
    @ObservedObject var viewModel = InscriptionAnimationJeuViewModel()
    @ObservedObject var planningViewModel: PlanningViewModel
    @State private var selectedZone: EspaceAvecPosteCreneau
    @State private var showingConfirmationAlert = false

    
    var completion: ((Bool) -> Void)
   
    
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    let idUser = UserDefaults.standard.integer(forKey: "iduser")

    init(festival: Festival, creneau: Creneau, completion: @escaping (Bool) -> Void) {
        self.selectedZone = EspaceAvecPosteCreneau()
        self.planningViewModel = PlanningViewModel()
        self.completion = completion
        viewModel.fetchListeZoneBenevole(festival: festival, creneau: creneau)
    }

    var body: some View {
        
        ScrollView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        Text("Veuillez sélectionner une zone")
                        if selectedZone.nom != "nom" {
                            Text("Zone choisie : \(selectedZone.nom)")
                        }
                        Button(action: {
                            showingConfirmationAlert = true
                        }) {
                            if selectedZone.nom != "nom" {
                                VStack(spacing: 10) {
                                    Text("Confirmer")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                            }
                        }
             
                        ForEach(Array(viewModel.listeZoneBenevole.keys.sorted()), id: \.self) { cle in
                            VStack(alignment: .leading) {
                                Text("\(cle) :")
                                    .font(.headline)
                                Picker("Choisir une zone", selection: $selectedZone) {
                                    ForEach(self.viewModel.listeZoneBenevole[cle]!.indices, id: \.self) { index in
                                        let souszone = self.viewModel.listeZoneBenevole[cle]![index]
                                        let capaciteRestante = souszone.PosteCreneaus.first?.capacite_restante ?? 0
                                        let capaciteTotale = souszone.PosteCreneaus.first?.capacite ?? 0
                                        let capaciteAffichee = "\(capaciteTotale - capaciteRestante)/\(capaciteTotale)"
                                        Text("\(souszone.nom) (\(capaciteAffichee))")
                                            .tag(souszone)
                                            .disabled(capaciteRestante <= 0)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    .padding()
                    .onChange(of: selectedZone) { newValue in
                        print("selected zone    ", selectedZone)
                    }
                    .alert(isPresented: $showingConfirmationAlert) {
                        return Alert(
                            title: Text("Confirmation"),
                            message: Text("Êtes-vous sûr de vouloir sélectionner cette zone ?"),
                            primaryButton: .default(Text("Oui")) {
                                let idfestival = selectedZone.PosteCreneaus[0].idfestival
                                let idcreneau = selectedZone.PosteCreneaus[0].idcreneau
                                let idposte = selectedZone.idposte
                                let idzonebenevole = selectedZone.idzonebenevole
                                planningViewModel.createInscriptionZone(idzonebenevole:idzonebenevole,idfestival : idfestival, idcreneau : idcreneau, idposte: idposte, iduser: idUser, token: token)
                                self.showingConfirmationAlert = false
                                completion(true)
                     
                                
                            },
                            secondaryButton: .cancel(Text("Annuler"))
                        )
                    }
                }
            }
        } 
    }
       
}
