import SwiftUI

struct Supervision: Codable {
    var iduser: Int
    var idposte: Int
    var idfestival: Int
    var User: User

enum CodingKeys: String, CodingKey {
    case iduser, idposte, idfestival, User
}
}
