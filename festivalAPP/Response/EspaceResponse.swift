//
//  EspaceResponse.swift
//  FestivalAPP
//
//  Created by etud on 20/03/2024.
//

import Foundation
struct EspaceSimpleResponse: Codable {
    let espaces : [Espace]
    init() {
            self.espaces = []
        }
}

struct EspaceComplexeResponse: Codable {
    let find: Bool
    let espaces: [EspaceAvecPosteCreneau]
}

struct EspaceAvecPosteCreneau: Codable, Hashable, Equatable {
    let idzonebenevole: Int
    let nom: String
    let idposte: Int
    let idzoneplan: Int?
    let Inscriptions: [InscriptionSimple]
    let PosteCreneaus: [PosteCreneau]
    
    init() {
            self.idzonebenevole = 0
            self.nom = "nom"
            self.idposte = 0
            self.idzoneplan = 0
            self.Inscriptions = []
            self.PosteCreneaus = []
        }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(idzonebenevole)
        hasher.combine(nom)
        hasher.combine(idposte)
        hasher.combine(idzoneplan)
    }
    
    static func == (lhs: EspaceAvecPosteCreneau, rhs: EspaceAvecPosteCreneau) -> Bool {
        return lhs.idzonebenevole == rhs.idzonebenevole &&
               lhs.nom == rhs.nom &&
               lhs.idposte == rhs.idposte &&
               lhs.idzoneplan == rhs.idzoneplan
    }
}
