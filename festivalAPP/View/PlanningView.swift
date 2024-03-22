import SwiftUI

struct PlanningView: View {
    
    var festival: Festival
    @ObservedObject var viewModel: PlanningViewModel
    
    @State private var selectedDateIndex = 0
    @State private var selectedHoraireIndex = 0
    
    @State private var showingConfirmationAlert = false
    @State private var selectedPoste: PosteCreneauComplexe?
    
    @State private var isChecked: Bool = false
    @State private var estInscrit: Bool = false
    
    @State private var showModal = false
    @State private var showingInscriptionAnimationJeu = false

    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    let idUser = UserDefaults.standard.integer(forKey: "iduser")
    
    init(festival: Festival) {
        self.festival = festival
        self.viewModel = PlanningViewModel()
        self.viewModel.fetchCreneauxListe(token: token, idFestival: festival.id)
        self.viewModel.fetchPostesCreneauxListe(token: token, idFestival: festival.id)
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                if !viewModel.creneaux.isEmpty {
                
                    Picker("Sélectionner une date", selection: $selectedDateIndex) {
                        ForEach(0..<viewModel.datesDistinctes.count, id: \.self) { index in
                            Text(viewModel.datesDistinctes[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if let selectedDate = viewModel.datesDistinctes[selectedDateIndex] {
                        // Filtrer les créneaux pour afficher seulement ceux correspondant à la date sélectionnée
                        let selectedDateString = viewModel.datesDistinctes[selectedDateIndex]
                        let creneauxPourDate = viewModel.creneaux.filter { $0.jour == selectedDateString }
                        let creneau = creneauxPourDate[selectedHoraireIndex]
                   

                        Text("Select a time:")
                        // Afficher les créneaux horaires filtrés
                        VStack {
                            Picker(selection: $selectedHoraireIndex, label: Text("")) {
                                ForEach(0..<creneauxPourDate.count, id: \.self) { index in
                                    let creneau = creneauxPourDate[index]
                                 
                                        Text("\(creneau.heure_debut) - \(creneau.heure_fin) \(creneau.id)")
                
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: selectedHoraireIndex) { newIndex in
                                let creneau = creneauxPourDate[newIndex]
                                PlanningUtils.fetchIsFlexible(idcreneau: creneau.id, iduser: idUser, token: token) { isFlexible in
                                    isChecked=isFlexible
                                }
                                PlanningUtils.fetchInscriptionByCreneau(idcreneau: creneau.id, iduser: idUser, token: token) { response in
                                    estInscrit=response
                                }
                            }
                            .onAppear{
                                PlanningUtils.fetchIsFlexible(idcreneau: creneau.id, iduser: idUser, token: token) { isFlexible in
                                    isChecked=isFlexible
                                }
                                PlanningUtils.fetchInscriptionByCreneau(idcreneau: creneau.id, iduser: idUser, token: token) { response in
                                    estInscrit=response
                                }
                            }
                        }
      
                        Button(action: {
                            if isChecked {
                                PlanningUtils.uncheck(idcreneau: creneau.id, iduser: idUser, token: token) { isFlexible in
                                    isChecked=isFlexible
                                }
                            } else {
                                PlanningUtils.check(idcreneau: creneau.id, iduser: idUser, token: token) { isFlexible in
                                    isChecked=isFlexible
                                }
                            }
                        }) {
                            if !estInscrit {
                                HStack {
                                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    
                                    Text(isChecked ?"Je suis Flexible":"Devenir bénévole flexible")
                                }
                            }else{
                                Text("Vous êtes déjà inscrit(e) sur ce créneau")
                            }
                        }
                        .padding()
                        
                        let selectedHoraire = creneauxPourDate[selectedHoraireIndex]
                        let postesAvecInscrits = viewModel.postescreneaux.filter { $0.creneau.jour == selectedDateString && $0.creneau.heure_debut == selectedHoraire.heure_debut && $0.creneau.heure_fin == selectedHoraire.heure_fin }
                        
                        let postesSansAnimationJeux = postesAvecInscrits.filter { $0.poste.nom != "Animation jeux" }
                        let postesAvecAnimationJeux = postesAvecInscrits.filter { $0.poste.nom == "Animation jeux" }
                        let sommeCapacites = postesAvecAnimationJeux.reduce(0) { $0 + $1.capacite }
                        let sommeCapacitesRestantes = postesAvecAnimationJeux.reduce(0) { $0 + $1.capacite_restante }
                        let selectedDate = creneauxPourDate[selectedHoraireIndex].jour
                        let selectedHeureDebut = creneauxPourDate[selectedHoraireIndex].heure_debut
                        let selectedHeureFin = creneauxPourDate[selectedHoraireIndex].heure_fin

                        ScrollView {
                            
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                Button(action: {
                                    showModal = true
                                }) {
                                    VStack(spacing: 10) {
                                        Text("Animation jeux")
                                            .font(.title)
                                        HStack {
                                            Spacer()
                                            Text("Capacité restante \(sommeCapacitesRestantes) / \(sommeCapacites)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                }
                                .disabled(isChecked || estInscrit )
                                .sheet(isPresented: $showModal) {
                                            // Vue modale à afficher lorsque le bouton est cliqué
                                    InscriptionAnimationJeu(festival: festival, creneau : creneauxPourDate[selectedHoraireIndex]){ success in
                                        // Traitement en fonction de la valeur retournée (success)
                                        if success {
                                            self.estInscrit = true
                                        } 
                                    }
                                        }
                                
                                ForEach(postesSansAnimationJeux.sorted(by: { $0.poste.nom < $1.poste.nom })) { posteCreneau in
                                    Button(action: {
                                        selectedPoste = posteCreneau
                                        self.showingConfirmationAlert = true
                               
                                    }) {
                                        VStack(spacing: 10) {
                                            Text(posteCreneau.poste.nom)
                                                .font(.title)
                                            HStack {
                                                Spacer()
                                                Text("Capacité restante \(posteCreneau.capacite_restante) / \(posteCreneau.capacite)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(12)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    }.disabled(isChecked || estInscrit)
                                }
                            }
                        }
                    }
                } else {
                    Text("Aucun créneau disponible")
                }
            }
        }
        .padding()
        .onAppear {
            fetchPostesCreneaux()
        }
        // Affichez la pop-up si showingConfirmationAlert est vrai
        .alert(isPresented: $showingConfirmationAlert) {
            // Créez une alerte de confirmation avec les options Oui et Annuler
            // Utilisez la désagrégation facultative pour extraire la valeur de selectedPoste
            if let poste = selectedPoste {
                // Créez une alerte de confirmation avec les options Oui et Annuler
                return Alert(
                    title: Text("Confirmation"),
                    message: Text("Êtes-vous sûr de vouloir sélectionner ce poste ?"),
                    primaryButton: .default(Text("Oui")) {
                        let idfestival = poste.idfestival
                        let idcreneau = poste.idcreneau
                        let idposte = poste.idposte
                        viewModel.createInscription(idfestival : idfestival, idcreneau : idcreneau, idposte: idposte, iduser: idUser, token: token)
                        estInscrit=true
                        
                    },
                    secondaryButton: .cancel(Text("Annuler"))
                )
            } else {
                // Si selectedPoste est nil, affichez une alerte vide
                return Alert(title: Text("Erreur"), message: Text("Poste non trouvé"), dismissButton: .cancel())
            }
        }
    }
    
    
    
        
    private func fetchPostesCreneaux() {
        guard !viewModel.creneaux.isEmpty else { return }
        let selectedDateString = viewModel.datesDistinctes[selectedDateIndex]
        let selectedHoraire = viewModel.creneaux[selectedHoraireIndex]
        viewModel.fetchPostesCreneauxListe(token: token, idFestival: festival.id)
    }
}
