import Foundation

struct Jeu: Codable, Identifiable {
    var id: Int {
        get { idjeu }
        set { idjeu = newValue }
    }
    
    var idjeu: Int
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
}

