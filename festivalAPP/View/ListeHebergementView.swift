import SwiftUI

struct ListeHebergementView: View {
    @ObservedObject private var viewModel: HebergementViewModel
    var festival: Festival
    var userId: Int = UserDefaults.standard.integer(forKey: "iduser")
    @State private var showingCreateHebergement = false
    @State private var selectedView = "Tous les hébergements" // There was a syntax error here with an extra '-' at the end, which I removed

    init(festival: Festival){
        self.festival = festival
        viewModel = HebergementViewModel()
    }

    var body: some View {
            VStack {
                Text("Liste des hébergements")
                Picker("Vue", selection: $selectedView) {
                    Text("Tous les hébergements").tag("Tous les hébergements")
                    Text("Mes hébergements").tag("Mes hébergements")
                }
                .pickerStyle(SegmentedPickerStyle())

                if festival.valide {
                    if selectedView == "Tous les hébergements" {
                        List {
                            ForEach(viewModel.hebergements, id: \.id) { hebergement in
                                VStack{
                                    HStack(alignment: .top) {
                                        Image(systemName: "house.fill")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.blue)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Image(systemName: "person.circle")
                                                    .resizable()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.gray)
                                                Text(hebergement.User.nom)
                                                    .foregroundColor(.gray)
                                            }
                                            HStack {
                                                Image(systemName: "pfcenterhone")
                                                    .resizable()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.gray)
                                                Text(hebergement.User.tel)
                                                    .foregroundColor(.gray)
                                            }
                                        } .alignmentGuide(.leading) { _ in 0 } 
                                        
                                        
                                    }
                                    .padding(.vertical, 8)
                                    HStack {
                                        Text("Nombre de places:")
                                            .foregroundColor(.gray)
                                        Text("\(hebergement.nb_places)")
                                            .foregroundColor(.gray)
                                    }
                                    HStack {
                                        Text("Description:")
                                            .foregroundColor(.gray)
                                        Text(hebergement.description)
                                            .foregroundColor(.gray)
                                    }.padding(.bottom,10)
                                }
                                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)) // Ajout de padding autour du VStack
                                .frame(maxWidth: .infinity, alignment: .leading) // Fixer la largeur et centrer les éléments à gauche
                                    .background(Color(UIColor.systemGray6)) // Ajout d'un fond pour le VStack
                                    .cornerRadius(10) // Coins arrondis
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1) // Ajout de la bordure avec la couleur et l'épaisseur souhaitées
                                    )
                            }


                        }
                    } else {
                        List {
                            ForEach(viewModel.userhebergements, id: \.id) { hebergement in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Hébergement :")
                                    
                                    Text("Nombre de places: \(hebergement.nb_places)")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                    Text("Description: \(hebergement.description)")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }.padding(10)
                            }
                            .onDelete { indexSet in
                                viewModel.deleteHebergements(idhebergement: viewModel.userhebergements[indexSet.first!].id, index: indexSet)
                                    viewModel.fetchHebergements(forFestivalId: self.festival.id)
                            }
                        }
                    }
                } else {
                    Text("PAS OUVERT")
                }
            }
            .navigationBarItems(
                leading: selectedView == "Mes hébergements" ? AnyView(Button(action: {
                    showingCreateHebergement = true
                }) {
                    Image(systemName: "plus")
                }) : AnyView(EmptyView()),
                trailing: selectedView == "Mes hébergements" ? AnyView(EditButton()) : AnyView(EmptyView())
            )

            .sheet(isPresented: $showingCreateHebergement) {
                CreateHebergementView(idfestival: festival.id, viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchHebergements(forFestivalId: festival.id)
                viewModel.fetchHebergementsByUser(userId: userId, idfestival: festival.id)
            }
        }
    
}
