//
//  PlanningViewModel.swift
//  FestivalAPP
//
//  Created by etud on 15/03/2024.
//

import Foundation

class PlanningViewModel: ObservableObject {
    
    @Published var creneaux: [Creneau] = []
    @Published var postescreneaux: [PosteCreneauComplexe] = []
    
    @Published var isLoading = false
    
    
    var datesDistinctes: [String] {
          
            var datesSet = Set<String>()
            
            // Parcourir les créneaux pour extraire les dates
            for creneau in creneaux {
                datesSet.insert(creneau.jour)
            }
            
            let dates = Array(datesSet).sorted()
            return dates
        }
    
    func fetchCreneauxListe(token: String, idFestival: Int) {
        
        isLoading = true
        
        guard let url = URL(string: "https://benevole-app-back.onrender.com/poste-creneau/get-creneaux-by-festival/\(idFestival)") else {
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
            
            do {
                let decoder = JSONDecoder()
                let jsonString = String(data: data, encoding: .utf8)
                                
                let decodedResponse = try decoder.decode(CreneauResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.creneaux = decodedResponse.creneaux
                   
                        print("Creneaux fetched successfully.")
                    }
                
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print(" error: \(error)")

            }
        }

        
        task.resume()
    }
    
    func creneauxPourDate(_ date: String) -> [Creneau] {
            return creneaux.filter { $0.jour == date }
        }
    
    func fetchPostesCreneauxListe(token: String, idFestival: Int) {
        
        isLoading = true
        
        guard let url = URL(string: "https://benevole-app-back.onrender.com/poste-creneau/get-by-festival/\(idFestival)") else {
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
            
            do {
                let decoder = JSONDecoder()
                let jsonString = String(data: data, encoding: .utf8)
                                
                let decodedResponse = try decoder.decode(PosteCreneauComplexResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.postescreneaux = decodedResponse.posteCreneau
            
                        print("posteCreneauComplexe fetched successfully.")
                    }
                
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print(" error: \(error)")

            }
                
            
        }

        
        task.resume()
    }
    
    func createInscription(idfestival : Int, idcreneau : Int, idposte: Int, iduser: Int, token: String){
        
        guard let url = URL(string: "https://benevole-app-back.onrender.com/inscription/create") else {
            print("URL is not valid.")
            return
        }
        
        // Création des données JSON
        var jsonData = ["iduser": iduser, "idcreneau": idcreneau, "idposte": idposte, "idfestival": idfestival, "idzonebenevole": nil]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error creating inscription: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    print("Inscription created successfully.")
                   
                    
                } else {
                    print("Failed to create inscription. Status code: \(httpResponse.statusCode)")
                }
            }
            
            task.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
    
    
    func createInscriptionZone(idzonebenevole:Int, idfestival : Int, idcreneau : Int, idposte: Int, iduser: Int, token: String){
        
        guard let url = URL(string: "https://benevole-app-back.onrender.com/inscription/create2") else {
            print("URL is not valid.")
            return
        }
        
        // Création des données JSON
        var jsonData = ["iduser": iduser, "idcreneau": idcreneau, "idposte": idposte, "idfestival": idfestival, "idzonebenevole": idzonebenevole]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error creating inscription: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    print("Inscription anim jeu created successfully.")
                } else {
                    print("Failed to create inscription. Status code: \(httpResponse.statusCode)")
                }
            }
            
            task.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
}
