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
                
                Text("Posté par \(viewModel.user?.pseudo ?? "Anonyme") le \(avis.date)")
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
            self.viewModel.fetchUserById(iduser: avis.iduser)
        }
        .padding(10)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(10)
        .padding(.vertical, 4)
    }
}
