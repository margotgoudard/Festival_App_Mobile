import Foundation

class HebergementViewModel: ObservableObject {
    @Published var hebergements: [Hebergement] = []
    @Published var userhebergements: [Hebergement] = []


    func fetchHebergements(forFestivalId festivalId: Int) {
                
        guard let url = URL(string: "https://benevole-app-back.onrender.com/hebergement/get-hebergement-by-festival/\(festivalId)") else {
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
                print("Error fetching hebergements: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            let decoder = JSONDecoder()
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
            do {
        
                let decodedResponse = try decoder.decode(HebergementResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.hebergements = decodedResponse.hebergements
                        print("Hebergements fetched successfully.")
                    }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print(" error: \(error)")

            }
        }.resume()
    }
    
    func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "token")
    }
    
    func fetchHebergementsByUser(userId: Int, idfestival: Int) {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/hebergement/get-hebergement-by-user/\(idfestival)/\(userId)") else {
            print("URL is not valid.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = getAuthToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Authentication token not found.")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching hebergements: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(HebergementResponse.self, from: data)
                DispatchQueue.main.async {
                    self.userhebergements = decodedResponse.hebergements
                    print("Hebergements fetched successfully for user ID: \(userId)")
                    print(self.userhebergements)
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func createHebergement(hebergement: Hebergement) {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/hebergement/create") else {
            print("URL is not valid.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = getAuthToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Authentication token not found.")
            return
        }
        
        let encoder = JSONEncoder()
        do {
            let hebergementData = [
                "distance": hebergement.distance,
                "description": hebergement.description,
                "nb_places": hebergement.nb_places,
                "iduser": hebergement.User.iduser,
                "idfestival": hebergement.idfestival
            ] as [String: Any]
            let jsonData = try JSONSerialization.data(withJSONObject: hebergementData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error encoding hebergement data: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error creating hebergement: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
                print("HTTP Error: Status code \(httpResponse.statusCode)")
                return
            }
            print("Hebergement created successfully.")
        }.resume()
    }
}
