import Foundation

class PosteViewModel: ObservableObject {
    @Published var festivals: [Festival] = []
    @Published var postes: [Poste] = []
    @Published var selectedFestivalId: Int?
    
    init() {
            fetchFestivals()
        }

    func fetchFestivals() {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/festival/all") else {
            print("URL is not valid.")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching festivals: \(error.localizedDescription)")
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
                
                let decodedResponse = try decoder.decode(FestivalsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.festivals = decodedResponse.festivals
                        print("Festivals fetched successfully.")
                    }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print("Decoding error:", error)

            }
        }.resume()
    }

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
            print(jsonString)
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

}
