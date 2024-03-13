import SwiftUI

struct Poste: Codable, Identifiable {
    var id: Int {
            get { idposte }
            set { idposte = newValue }
        }
    var idposte: Int
    var nom: String
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case idposte = "idposte"
        case nom
        case description
    }
}
