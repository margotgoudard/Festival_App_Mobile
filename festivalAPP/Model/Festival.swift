import Foundation

class Festival: Identifiable, ObservableObject, Decodable {
    var id: Int
    var annee: Int
    var valide: Bool
    var date_debut: Date?
    var date_fin: Date?
    var nom: String
    
    
    init(id: Int, annee: Int, valide: Bool, date_debut: Date, date_fin: Date, nom: String) {
        self.id = id
        self.annee = annee
        self.valide = valide
        self.date_debut = date_debut
        self.date_fin = date_fin
        self.nom = nom
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idfestival"
        case annee
        case valide
        case date_debut
        case date_fin
        case nom
    }
}

