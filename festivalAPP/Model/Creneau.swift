import Foundation

struct Creneau: Codable, Identifiable {
        var id: Int
        var jour: String
        var heure_debut: String
        var heure_fin: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idcreneau"
        case jour
        case heure_debut
        case heure_fin
    }
}

