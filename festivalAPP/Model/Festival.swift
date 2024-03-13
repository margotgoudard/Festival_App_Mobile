import Foundation

struct Festival: Codable, Identifiable {
    var id: Int {
            get { idfestival }
            set { idfestival = newValue }
        }
    var idfestival: Int
    var annee: Int
    var valide: Bool
    var date_debut: Date?
    var date_fin: Date?
    var nom: String
    
    enum CodingKeys: String, CodingKey {
        case idfestival = "idfestival"
        case annee
        case valide
        case date_debut = "date_debut"
        case date_fin = "date_fin"
        case nom
    }
}

