import Foundation
struct InscriptionSimpleResponse: Codable {
    let find : Bool
    let inscriptions: [InscriptionSimple]
}
