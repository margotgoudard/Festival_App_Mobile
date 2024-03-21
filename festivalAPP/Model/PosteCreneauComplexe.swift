//
//  PosteCreneauComplexe.swift
//  FestivalAPP
//
//  Created by etud on 15/03/2024.
//

import Foundation

struct PosteCreneauComplexe: Codable, Identifiable {
    
    var id: Int
    var idposte: Int
    var idcreneau: Int
    var idzonebenevole: Int
    var idfestival: Int
    var capacite: Int
    var capacite_restante: Int
    var creneau: Creneau
    var poste: Poste
    var inscription: [InscriptionSimple]
    
    
    
    enum CodingKeys: String, CodingKey {
        case id = "idpc"
        case idposte
        case idcreneau
        case idzonebenevole
        case idfestival
        case capacite
        case capacite_restante
        case creneau = "Creneau"
        case poste = "Poste"
        case inscription = "Inscriptions"
    }
}

