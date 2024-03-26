import SwiftUI

struct AvisDisplayView: View {
    var avis: Avis
    let idUser: Int
    var onEdit: () -> Void
    var onDelete: () -> Void
    @State private var showAlert = false
    @ObservedObject var viewModel = UserViewModel()
    @State private var userPseudo: String = ""


    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(avis.texte)
                    .font(.headline)
                
                Text("Posté par \(userPseudo) le \(formattedDate)")
                    .font(.caption)
                    .foregroundColor(.gray)

            }
            Spacer()
            if avis.iduser == idUser {
                Button(action: onEdit) {
                    Image(systemName: "pencil").foregroundColor(.blue)
                }
                Button(action: {
                    self.showAlert = true
                }) {
                    Image(systemName: "trash").foregroundColor(.red)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Suppression"),
                        message: Text("Voulez-vous vraiment supprimer cet avis définitivement ?"),
                        primaryButton: .destructive(Text("Supprimer")) {
                            onDelete()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }.onAppear {
            self.viewModel.fetchUserById(iduser: avis.iduser) { result in
                switch result {
                case .success(let user):
                    self.userPseudo = user.pseudo
                case .failure(let error):
                    print("Error fetching user: in avis")
                }
            }
        }
        .padding(10)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(10)
        .padding(.vertical, 4)
    }
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Format de date souhaité
        return dateFormatter.string(from: avis.date)
    }
}
