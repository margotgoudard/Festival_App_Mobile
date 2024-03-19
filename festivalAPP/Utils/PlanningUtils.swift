//
//  PlanningUtils.swift
//  FestivalAPP
//
//  Created by etud on 19/03/2024.
//

import Foundation

class PlanningUtils: ObservableObject {
    static func fetchIsFlexible(idcreneau: Int, iduser: Int, token: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/flexible/get-one") else {
            print("URL is not valid.")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        let jsonData = ["iduser": iduser, "idcreneau": idcreneau]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Erreur lors de la sérialisation JSON : \(error)")
            completion(false)
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching postes: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(false)
                return
            }
            
            let decoder = JSONDecoder()
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
            
            do {
                let decodedResponse = try decoder.decode(FlexibleResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.find ?? false)
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print(" error: \(error)")
                completion(false)
                return
            }
        }.resume()
    }

        
        // Fonction appelée lorsque l'utilisateur coche le checkbox
    static func check(idcreneau: Int, iduser: Int, token: String, completion: @escaping (Bool) -> Void)  {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/flexible/create") else {
            print("URL is not valid.")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        let jsonData = ["iduser": iduser, "idcreneau": idcreneau]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Erreur lors de la sérialisation JSON : \(error)")
            completion(false)
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching postes: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(false)
                return
            }
            
            let decoder = JSONDecoder()
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
            
            do {
                let decodedResponse = try decoder.decode(FlexibleResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.created ?? false)
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print(" error: \(error)")
                completion(false)
                return
            }
        }.resume()
   
        }
        
        // Fonction appelée lorsque l'utilisateur décoche le checkbox
    static func uncheck(idcreneau: Int, iduser: Int, token: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/flexible/delete") else {
            print("URL is not valid.")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        let jsonData = ["iduser": iduser, "idcreneau": idcreneau]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Erreur lors de la sérialisation JSON : \(error)")
            completion(false)
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching postes: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(false)
                return
            }
            
            let decoder = JSONDecoder()
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
            
            do {
                let decodedResponse = try decoder.decode(FlexibleResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.delete ?? false)
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print(" error: \(error)")
                completion(false)
                return
            }
        }.resume()
   
        }
    
    static func fetchInscriptionByCreneau(idcreneau: Int, iduser: Int, token: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/inscription/get-by-user/\(iduser)/\(idcreneau)"
        ) else {
            print("URL is not valid.")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching postes: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(false)
                return
            }
            
            let decoder = JSONDecoder()
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
            
            do {
                let decodedResponse = try decoder.decode(InscriptionSimpleResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.find ?? false)
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print(" error: \(error)")
                completion(false)
                return
            }
        }.resume()
   
        
    }
    
}
