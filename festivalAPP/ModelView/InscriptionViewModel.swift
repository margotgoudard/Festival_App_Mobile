import Foundation

class InscriptionViewModel: ObservableObject {
    @Published var inscriptions: [Inscription] = []
    @Published var isLoading = false
    @Published var notification: String = ""
    @Published var groupedInscriptionsByDayAndTime: [String: [String: [Inscription]]] = [:]
    @Published var showAlertValidation = false
    @Published var showAlertSuppression = false
    private var festivalId: Int = 0


    func groupInscriptions() {
        DispatchQueue.main.async {
            self.groupedInscriptionsByDayAndTime = Dictionary(grouping: self.inscriptions, by: { $0.creneau.jour })
                .mapValues { Dictionary(grouping: $0, by: { $0.creneau.heure_debut }) }

        }
    }

    func fetchInscriptions(idUser: Int, idFestival: Int) {
        festivalId = idFestival
           guard let url = URL(string: "https://benevole-app-back.onrender.com/inscription/user/\(idUser)/\(idFestival)")
            else {
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
    
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonString = String(data: data, encoding: .utf8)
                print(jsonString)
                
                let decodedResponse = try decoder.decode(InscriptionResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.inscriptions = decodedResponse.inscriptions
                        print("Inscriptions fetched successfully.")
                    }
                DispatchQueue.main.async {
                    self.groupedInscriptionsByDayAndTime = Dictionary(grouping: self.inscriptions, by: { $0.creneau.jour })
                        .mapValues { Dictionary(grouping: $0, by: { $0.creneau.heure_debut }) }

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
    
    func validateInscription(inscriptionId: Int, valide: Bool) {
        print(valide)
        guard let url = URL(string: "https://benevole-app-back.onrender.com/inscription/validation") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = getAuthToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let body: [String: Any] = [
            "idinscription": inscriptionId,
            "valide": valide
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.notification = "Error validating inscription: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.notification = "Error validating inscription: Invalid response from server."
                }
                return
            }
            
            DispatchQueue.main.async {
                        let idUser = UserDefaults.standard.integer(forKey: "iduser")
                        self.fetchInscriptions(idUser: idUser, idFestival: self.festivalId)
                    }
            
            DispatchQueue.main.async {
                          if valide {
                              self.showAlertValidation = true
                          } else {
                              self.showAlertSuppression = true
                          }
                      }
        }

        task.resume()
    }


}
