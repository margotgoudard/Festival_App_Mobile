import SwiftUI

struct Navbar: View {
    var festival: Festival
    @ObservedObject var viewModel =  NotificationsViewModel()
    @ObservedObject private var viewModel2: JeuViewModel = JeuViewModel()
    
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    let idUser = UserDefaults.standard.integer(forKey: "iduser")
    
    init(festival: Festival) {
        self.festival = festival
        viewModel.fetchNotifications(token: token, idUser: idUser, idFestival: festival.id)
        viewModel2.fetchEspaces(forFestivalId: festival.id)
    }
    
    var body: some View {
        VStack {
            TabView {
                NavigationView {
                    ListeJeuView(festival: festival, viewModel: viewModel2)
                }
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Jeux")
                }
                .tag(2)
                NavigationView {
                    ListeInscriptionView(festival: festival)
                }
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Inscription")
                }
                .tag(0)
                
                
                
                NavigationView {
                    ListePosteView(festival: festival)
                }
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Postes")
                }
                .tag(1)
                
                
                
                NavigationView {
                    NotificationView(festival: festival,viewModel: viewModel)
                }
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notification")
                }
                .tag(4)
                .badge(viewModel.countNotifications())
                
                
                NavigationView {
                    PlanningView(festival: festival)
                }
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Planning")
                }
                .tag(6)
            }
            .accentColor(.blue) // Modifier la couleur de l'élément sélectionné ici
            
        }
        
        
    }
}
