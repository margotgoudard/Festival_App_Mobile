import Foundation

struct Creneau: Codable, Identifiable {
    var id: Int {
            get { idcreneau }
            set { idcreneau = newValue }
        }
        var idcreneau: Int
        var jour: String
        var heure_debut: String
        var heure_fin: String
    
    enum CodingKeys: String, CodingKey {
        case idcreneau = "idcreneau"
        case jour
        case heure_debut
        case heure_fin
    }
}

