import SwiftUI

struct Espace: Codable,Identifiable {
    var id: Int {
            get { idzonebenevole }
            set { idzonebenevole = newValue }
        }
    
    var idzonebenevole: Int
    var nom: String
    var idzoneplan: Int?
    var idposte: Int

}
