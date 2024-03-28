import Foundation

class AvisViewModel: ObservableObject {
    
    @Published var avis: [Avis] = []
    @Published var avisEnCoursDeModification: Avis?
    
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

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" 
        let dateString = dateFormatter.string(from: date)

        let body: [String: Any] = [
            "texte": texte,
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
                    
        
                    let newAvis = Avis(idavis: 0, texte: texte, date: date, iduser: iduser, idfestival: idfestival)
                  
                    DispatchQueue.main.async {
                        self.avis.append(newAvis)
                        self.avis = self.avis.sorted { $0.date > $1.date }
                        self.objectWillChange.send()
                    }
                } else {
                    print("Failed to create avis.")
                }
            }

            
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
                    self.avis = decodedResponse.avis.sorted { $0.date > $1.date }
                    print("Avis fetched successfully.")
                    
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }

    
    func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "token")
    }
    
    func deleteAvis(idavis: Int, idfestival : Int) {
        
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
                    print("Error deleting avis: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    print("AVis deleted successfully.")
                    self.objectWillChange.send()
                    
                } else {
                    print("Failed to delete avis. Status code: \(httpResponse.statusCode)")
                }
                DispatchQueue.main.async {
                           self.fetchAvis(forFestivalId: idfestival)
                       }
            }
            
            task.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
    
    func updateAvis(idavis: Int, texte: String, date: Date, idfestival : Int) {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/avis/\(idavis)") else {
            print("URL is not valid.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = getAuthToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Token d'authentification non trouvé.")
            return
        }
        
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let jsonData = ["texte": texte, "date": dateString]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Failed to serialize JSON body: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating avis: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response received or failed to update avis.")
                return
            }
            
            print("Avis updated successfully.")
            DispatchQueue.main.async {
                       self.fetchAvis(forFestivalId: idfestival)
                   }
        }.resume()
    }

}

