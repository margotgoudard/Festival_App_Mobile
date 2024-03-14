import Foundation

class JeuViewModel: ObservableObject {
    @Published var espaces: [Espace] = []
    @Published var selectedZone: Espace?
    @Published var jeux: [Jeu] = []

    func fetchEspaces(forFestivalId festivalId: Int) {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/espace/allespaces") else {
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
                print("Error fetching espaces: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            let decoder = JSONDecoder()
            let jsonString = String(data: data, encoding: .utf8)
   
            do {
                let decodedResponse = try decoder.decode(JeuEspaceResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.espaces = decodedResponse.espaces
                        self.selectedZone = self.espaces[0]
                        self.fetchJeux(forEspaceId: self.espaces[0].idzonebenevole)
                        print("espaces fetched successfully.")
                    }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print(" error: \(error)")

            }
        }.resume()
    }
    
    func fetchJeux(forEspaceId espaceId: Int) {
        print("espace    ", espaceId)
        guard let url = URL(string: "https://benevole-app-back.onrender.com/jeu/all?idzonebenevole=\(espaceId)") else {
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
                let decodedResponse = try decoder.decode(JeuResponse.self, from: data)
                    DispatchQueue.main.async {
                        let jeuData : [JeuData] = decodedResponse.jeux
                        
                        self.jeux = jeuData.flatMap { $0.Jeu }
            
                        print("jeux fetched successfully.")
                    }
            } catch {
                print("Decoding jeu error: \(error.localizedDescription)")
                print(" error: \(error)")

            }
        }.resume()
    }
    
    func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "token")
    }

}
