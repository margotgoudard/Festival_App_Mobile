import SwiftUI

struct FestivalView: View {
    var festival: Festival
    @State private var isMenuVisible = false


    var body: some View {
        Text(festival.nom)
        
        Button(action: {
            isMenuVisible.toggle()
        }) {
            Image(systemName: "line.horizontal.3")
                .font(.title)
                .foregroundColor(.blue)
        }
        
        if isMenuVisible {
            Navbar(festival: festival)
        }
    }
}
