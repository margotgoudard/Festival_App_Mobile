import Foundation

struct Jeu: Codable, Identifiable {
    var id: Int
    var nom: String
    var auteur: String?
    var editeur: String?
    var nbjoueurs: String?
    var agemin: String?
    var duree: String?
    var type: String?
    var notice: String?
    var aanimer: Bool?
    var recu: Bool
    var mecanismes: String?
    var themes: String?
    var tags: String?
    var description: String?
    var image: String?
    var logo: String?
    var video: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idjeu"
        case nom
        case auteur
        case editeur
        case nbjoueurs
        case agemin
        case duree
        case type
        case notice
        case aanimer
        case recu
        case mecanismes
        case themes
        case tags
        case description
        case image
        case logo
        case video
    }
    
}

