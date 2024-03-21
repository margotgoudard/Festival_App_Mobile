import SwiftUI

struct PosteDetailView: View {
    @ObservedObject var viewModel: PosteViewModel
    let poste: Poste
    var festival: Festival
    
    init(poste: Poste, festival: Festival) {
        self.poste = poste
        self.festival = festival
        self.viewModel = PosteViewModel()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(poste.description ?? "Pas de description disponible")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .navigationTitle(poste.nom)

                Divider()

                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.referents, id: \.User.iduser) { referent in
                        VStack(alignment: .leading) {
                            Text("\(referent.User.nom) \(referent.User.prenom)")
                                .fontWeight(.semibold)
                            Text("Tél: \(referent.User.tel)")
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            viewModel.fetchReferents(forPosteId: poste.id, festivalId: festival.id)
        }
    }
}
