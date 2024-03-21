//
//  NotificationsModelView.swift
//  FestivalAPP
//
//  Created by etud on 14/03/2024.
//


import Foundation

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    @Published var isLoading = false
    
    func fetchNotifications(token: String, idUser: Int, idFestival: Int) {
        
        isLoading = true
        
        guard let url = URL(string: "https://benevole-app-back.onrender.com/notification/get-by-user/\(idUser)/\(idFestival)") else {
            print("URL is not valid.")
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
            
            if let error = error {
                print("Error fetching notifications: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            /*
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }*/
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(NotificationResponse.self, from: data)
                DispatchQueue.main.async {
                    self.notifications = decodedResponse.notifications
                    print("Notifications fetched successfully.")
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }
        
        
        

        
        task.resume()
    }
    
    func deleteNotifications(token: String,idnotif: Int, index: IndexSet) {
        
        guard let url = URL(string: "https://benevole-app-back.onrender.com/notification/delete") else {
            print("URL is not valid.")
            return
        }
        
        // Création des données JSON
        let jsonData = ["idnotification": idnotif]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error deleting notification: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    print("Notification deleted successfully.")
                    // Mettez à jour la liste des notifications ou effectuez d'autres actions si nécessaire
                    self.notifications.remove(atOffsets: index)
                    self.objectWillChange.send()
                    
                } else {
                    print("Failed to delete notification. Status code: \(httpResponse.statusCode)")
                }
            }
            
            task.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
    
    
    func countNotifications() -> Int {
        return notifications.count
    }
}
