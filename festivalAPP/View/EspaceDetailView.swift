import SwiftUI

struct EspaceDetailView: View {
    let espace: Espace
    let jeux: [Jeu]
    
    @State private var flipped: [Int: Bool] = [:]

    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .center, spacing: 20) {
                Text(espace.nom)
                    .navigationTitle(espace.nom)
                    .frame(maxWidth: .infinity)

                List(jeux, id: \.id) { jeu in
                    ZStack(alignment: .center) {
                        Group {
                            if flipped[jeu.id, default: false] {
                                VStack(alignment: .center) {
                                    Text(jeu.nom).font(.headline)
                                    Text("Reçu: \(jeu.recu ? "Oui" : "Non")")
                                    if let noticeURL = jeu.notice, let url = URL(string: noticeURL) {
                                        Link("Notice", destination: url)
                                    } else {
                                        Text("Notice: Non disponible")
                                    }
                                }
                                .rotation3DEffect(Angle.degrees(360), axis: (x: 0, y: 0, z: 0))
                            } else {
                                if let imageURL = jeu.image, let url = URL(string: imageURL) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                            case .success(let image):
                                                image.resizable().scaledToFit()
                                            case .failure(_):
                                            Image(uiImage: UIImage(named: "placeholder.png")!)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                            case .empty:
                                                ProgressView().frame(maxWidth: .infinity)
                                            @unknown default:
                                                EmptyView()
                                        }
                                    }
                                    .frame(width: 100, height: 100)
                                } else {
                                    Image("placeholder") // Utiliser l'image de remplacement si l'URL est nulle
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            withAnimation {
                                flipped[jeu.id] = !(flipped[jeu.id, default: false])
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
