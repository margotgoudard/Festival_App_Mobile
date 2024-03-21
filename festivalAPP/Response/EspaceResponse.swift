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

struct EspaceAvecPosteCreneau: Codable {
    let idzonebenevole: Int
    let nom: String
    let idposte: Int
    let idzoneplan: Int?
    let Inscriptions: [Inscription]
    let PosteCreneaus: [PosteCreneau]
    
    init() {
            self.idzonebenevole = 0
            self.nom = "nom"
            self.idposte = 0
            self.idzoneplan = 0
            self.Inscriptions = []
            self.PosteCreneaus = []
        }
}
