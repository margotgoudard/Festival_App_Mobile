import SwiftUI
struct FestivalView: View {
    var festival: Festival
    @State private var isMenuVisible = false
   

    var body: some View {
        Text(festival.nom)
        
        
        Navbar(festival: festival)
        
    }
}
