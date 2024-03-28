import Foundation
import SwiftUI

struct FlexibleUserCreneau: Codable, Identifiable {
    var id: Int
    var idcreneau: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "iduser"
        case idcreneau
        
    }
}
