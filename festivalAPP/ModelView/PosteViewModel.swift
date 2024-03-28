import Foundation

class PosteViewModel: ObservableObject {
    @Published var postes: [Poste] = []
    @Published var selectedPoste: Poste?
    @Published var referents: [Supervision] = []


    func fetchPostes(forFestivalId festivalId: Int) {
                
        guard let url = URL(string: "https://benevole-app-back.onrender.com/poste-creneau/get-poste-by-festival/\(festivalId)") else {
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
                print("Error fetching postes: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            let decoder = JSONDecoder()
            let jsonString = String(data: data, encoding: .utf8)
            do {
        
                let decodedResponse = try decoder.decode(PosteReponse.self, from: data)
                    DispatchQueue.main.async {
                        self.postes = decodedResponse.postes
                        print("Postes fetched successfully.")
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
    
    func fetchReferents(forPosteId posteId: Int, festivalId: Int) {
        print(festivalId)
        guard let url = URL(string: "https://benevole-app-back.onrender.com/supervision/getByPoste") else {
            print("URL is not valid.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = getAuthToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Token d'authentification non trouvé.")
            return
        }

        let bodyContent = ["idposte": posteId, "idfestival": festivalId]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyContent, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Error fetching referents: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    print("No data received.")
                }
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print("Received JSON string: \(jsonString)")
                }
            }

            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(SupervisionResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.referents = decodedResponse.referents
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
}
