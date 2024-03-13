import Foundation

class FestivalUtils: ObservableObject {
    
    @Published var selectedFestivalId: Int = 0
    @Published var selectedFestival: Festival? = nil
    @Published var festivals: [Festival] = []
    
    init(){
        self.fetchFestivals { _, _ in }
    }
    
    func setSelectedFestival(){
        DispatchQueue.main.async {
            self.selectedFestival = self.festivals.first(where: { $0.idfestival == self.selectedFestivalId })
        }
    }
    
    func fetchFestivals(completion: @escaping ([Festival]?, Error?) -> Void) {
        guard let url = URL(string: "https://benevole-app-back.onrender.com/festival/all") else {
            print("URL is not valid.")
            completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "L'URL est invalide"]))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching festivals: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil, NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "Aucune donnée reçue"]))
                return
            }
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
                let decodedResponse = try decoder.decode(FestivalsResponse.self, from: data)
                let filteredFestivals = decodedResponse.festivals.filter { festival in
                        if let endDate = festival.date_fin {
                            return endDate > Date()
                        }
                        return false
                }
                

                DispatchQueue.main.async {
                    self.festivals=filteredFestivals
                    self.selectedFestivalId=self.festivals[0].idfestival
                    self.setSelectedFestival()
                    completion(filteredFestivals, nil)
                    print("Festivals fetched successfully.")
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print("Decoding error:", error)
                completion(nil, error)
            }
        }.resume()
    }
    
}
