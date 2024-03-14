import SwiftUI

struct Poste: Codable, Identifiable {
    var id: Int
    var nom: String
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idposte"
        case nom
        case description
    }
}
