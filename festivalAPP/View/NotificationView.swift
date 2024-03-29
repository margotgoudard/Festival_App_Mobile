import SwiftUI

struct NotificationView: View {
    
    @ObservedObject var viewModel: NotificationsViewModel
    var festival: Festival
   
    init(festival: Festival, viewModel:NotificationsViewModel){
        self.festival = festival
        self.viewModel = viewModel
    }
    
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    let idUser = UserDefaults.standard.integer(forKey: "iduser")
    
    var body: some View {
        VStack {
            Text("Mes notifications")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .multilineTextAlignment(.center)
            if (festival.valide) {
            if viewModel.isLoading {
                ProgressView()
            }
            else {
                if viewModel.notifications.isEmpty {
                    Text("Aucune notification")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.notifications) { notif in
                            Text(notif.label)
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        }
                        .onDelete { indexSet in
                            let firstIndex = indexSet.first
                            guard let firstIndex = indexSet.first else { return }
                            let id = viewModel.notifications[firstIndex].idnotification
                            print(id)
                            viewModel.deleteNotifications(token: token, idnotif: id, index: indexSet)
                        }
                    }
                }
            }
        } else {
            VStack {
                Text("PAS OUVERT")
            }.onAppear {
                print("test")
            }
        }
        }
        .navigationBarItems(trailing: EditButton())
        .onAppear {
            viewModel.fetchNotifications(token: token, idUser: idUser, idFestival: festival.id)
        }
    }
}

