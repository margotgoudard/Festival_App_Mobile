//
//  InscriptionSimple.swift
//  FestivalAPP
//
//  Created by etud on 15/03/2024.
//

import Foundation

struct InscriptionSimple: Codable {
    var id: Int
    var idposte: Int
    var idcreneau: Int
    var iduser: Int
    var idzonebenevole: Int
    var idfestival: Int
    var valide: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "idinscription"
        case idposte
        case idcreneau
        case iduser
        case idzonebenevole
        case idfestival
        case valide
    }
}
