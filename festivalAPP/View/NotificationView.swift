//
//  NotificationView.swift
//  FestivalAPP
//
//  Created by etud on 14/03/2024.
//
import SwiftUI

struct NotificationView: View {
    
    @ObservedObject var viewModel = NotificationsViewModel()
    @ObservedObject private var festivalUtils = FestivalUtils()
    
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    let idUser = UserDefaults.standard.integer(forKey: "iduser")
    
    var body: some View {
        VStack {
            
            if viewModel.isLoading {
                ProgressView()
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
        .padding(.horizontal, 10)
        .navigationTitle("Notifications")
        .navigationBarItems(trailing: EditButton())
        .onAppear {
            viewModel.fetchNotifications(token: token, idUser: idUser, idFestival: 6)
        }
    }
}
