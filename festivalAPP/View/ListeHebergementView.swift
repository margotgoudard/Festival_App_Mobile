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
                Picker("Vue", selection: $selectedView) {
                    Text("Tous les hébergements").tag("Tous les hébergements")
                    Text("Mes hébergements").tag("Mes hébergements")
                }
                .pickerStyle(SegmentedPickerStyle())

                if festival.valide {
                    if selectedView == "Tous les hébergements" {
                        List {
                            ForEach(viewModel.hebergements, id: \.id) { hebergement in
                                Text("\(hebergement.User.nom) : \(hebergement.User.tel)")
                            }
                        }
                    } else {
                        List {
                            ForEach(viewModel.userhebergements, id: \.id) { hebergement in
                                Text(hebergement.description)
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
