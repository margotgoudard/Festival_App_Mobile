import Foundation

class Hebergement: Identifiable, Codable {
    var id: Int
    var nb_places: Int
    var distance: Int?
    var description: String
    var User: User
    var idfestival: Int
    
    
    init(id: Int, nb_places: Int, distance: Int, user: User, idfestival: Int, description: String) {
        self.id = id
        self.description = description
        self.nb_places = nb_places
        self.distance = distance
        self.User = user
        self.idfestival = idfestival
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idhebergement"
        case nb_places
        case distance
        case User
        case idfestival
        case description
    }
}

