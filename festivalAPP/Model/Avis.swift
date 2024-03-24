import Foundation

struct Avis: Decodable{
    var id: Int {
            get { idavis }
            set { idavis = newValue }
        }
    var idavis: Int
    var texte: String
    var date: Date?
    var iduser: Int
    var idfestival : Int

    
    enum CodingKeys: String, CodingKey {
        case idavis = "idavis"
        case texte
        case date
        case iduser
        case idfestival
    }
    
}
