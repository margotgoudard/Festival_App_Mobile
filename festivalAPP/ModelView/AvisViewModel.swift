import Foundation

class AvisViewModel: ObservableObject {
    
    @Published var avis: [Avis] = []
    
    init(idfestival: Int) {
        fetchAvis(forFestivalId: idfestival)
    }
    
    func ajouterAvis(texte: String, idfestival: Int, iduser: Int, date: Date) {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/avis/create") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create a DateFormatter to convert the Date to a String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the format as needed
        let dateString = dateFormatter.string(from: date)

        let body: [String: Any] = [
            "texte": texte,
            // Use the dateString instead of the Date object
            "date": dateString,
            "iduser": iduser,
            "idfestival": idfestival
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize JSON body: \(error.localizedDescription)")
            return
        }

        if let token = getAuthToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Token d'authentification non trouvé.")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }

            // Optionally, handle the response here
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 201 {
                    print("Avis created successfully.")
                    
                    // Ajout de l'avis à la liste locale
                    let newAvis = Avis(idavis: 0, texte: texte, date: date, iduser: iduser, idfestival: idfestival)
                    
                    // Émettre un signal pour notifier les vues de la mise à jour
                    DispatchQueue.main.async {
                        self.avis.append(newAvis)
                        self.objectWillChange.send()
                    }
                } else {
                    print("Failed to create avis.")
                }
            }

            // Debugging purpose: print the response data
            if let responseBody = String(data: data, encoding: .utf8) {
                print(responseBody)
            }
        }.resume()
    }


    func fetchAvis(forFestivalId festivalId: Int) {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/avis/get-all-avis/\(festivalId)") else {
            print("URL is not valid.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = getAuthToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Token d'authentification non trouvé.")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching avis: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            
            
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
                let decodedResponse = try decoder.decode(AvisResponse.self, from: data)
                DispatchQueue.main.async {
                    // Set the fetched avis to your property
                    self.avis = decodedResponse.avis
                    print("Avis fetched successfully.")
                    
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }

    
    func getAuthToken() -> String? {
        print(UserDefaults.standard.string(forKey: "token"))
        return UserDefaults.standard.string(forKey: "token")
    }
    
    func deleteAvis(idavis: Int) {
        
        guard let url = URL(string: "https://benevole-app-back.onrender.com/avis/delete/\(idavis)") else {
            print("URL is not valid.")
            return
        }
        
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            if let token = getAuthToken() {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                print("Token d'authentification non trouvé.")
                return
            }
            

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
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
    
    
    
}

