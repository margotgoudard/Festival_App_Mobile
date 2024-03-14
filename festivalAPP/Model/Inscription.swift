import Foundation

struct Inscription: Identifiable, Codable {
    var id: Int {
            get { idinscription }
            set { idinscription = newValue }
        }
    var idinscription: Int
    var idposte: Int
    var idcreneau: Int
    var iduser: Int
    var idzonebenevole: Int
    var idfestival: Int
    var valide: Bool
    var creneau : Creneau
    var espace : Espace
    var poste : Poste
    var user : User

enum CodingKeys: String, CodingKey {
        case idinscription = "idinscription"
        case idposte
        case idcreneau
        case iduser
        case idzonebenevole
        case idfestival
        case valide
        case creneau = "Creneau" // Adjusted to match JSON key
        case espace = "Espace" // Adjusted to match JSON key
        case poste = "Poste" // Adjusted to match JSON key
        case user = "User"
    }
}
