import SwiftUI

struct Espace: Codable,Identifiable,Equatable {
    var id: Int
    var nom: String
    var idzoneplan: Int?
    var idposte: Int

    enum CodingKeys: String, CodingKey {
        case id = "idzonebenevole"
        case nom
        case idzoneplan
        case idposte
    }
    init() {
           
            self.idposte = 0
            self.nom=""
            self.idzoneplan = 0
            self.id = 0
        }
}
