import SwiftUI

struct FestivalDetailsHeaderView: View {
    var festival: Festival
    
    // URLs for social media
    let instagramURL = URL(string: "https://www.instagram.com/festivaldujeumontpellier/")!
    let twitterURL = URL(string: "https://twitter.com/FestivalJeuMpl")!
    let facebookURL = URL(string: "https://fr-fr.facebook.com/festivaldujeudemontpellier/")!
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(festival.nom)
                .font(.title.bold())
                .foregroundColor(Color.primary)
                .padding(.vertical, 5)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.secondary)
                Text("Dates: \(festival.date_debut?.formatted(date: .abbreviated, time: .omitted) ?? "N/A") - \(festival.date_fin?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
                    .font(.body)
            }
            
            Divider()
        
            HStack {
                Spacer()
                // Instagram button
                Link(destination: instagramURL) {
                    Image(uiImage: UIImage(named: "instagram.png")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue) // Apply if you want color overlay
                }
                Spacer()
                // Twitter button
                Link(destination: twitterURL) {
                    Image(uiImage: UIImage(named: "X.png")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.blue)
                }
                Spacer()
                // Facebook button
                Link(destination: facebookURL) {
                    Image(uiImage: UIImage(named: "facebook.png")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                }
                Spacer()
            }.padding(.vertical, 5)
            
            Spacer()
        }
        .padding(.horizontal)
        .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemBackground), Color(UIColor.secondarySystemBackground)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}
