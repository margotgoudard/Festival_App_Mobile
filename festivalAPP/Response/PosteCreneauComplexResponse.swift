import Foundation
struct PosteCreneauComplexResponse: Codable {
    let find: Bool
    let posteCreneau: [PosteCreneauComplexe]
        
    enum CodingKeys: String, CodingKey {
        case find
        case posteCreneau
    }
}
