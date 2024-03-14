import SwiftUI

struct Espace: Codable,Identifiable,Equatable {
    var id: Int {
            get { idzonebenevole }
            set { idzonebenevole = newValue }
        }
    
    var idzonebenevole: Int
    var nom: String
    var idzoneplan: Int?
    var idposte: Int

    enum CodingKeys: String, CodingKey {
        case idzonebenevole = "idzonebenevole"
        case nom
        case idzoneplan
        case idposte
    }
}
