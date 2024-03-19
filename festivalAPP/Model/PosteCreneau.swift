//
//  PosteCreneau.swift
//  FestivalAPP
//
//  Created by etud on 15/03/2024.
//
import Foundation

struct PosteCreneau: Codable, Identifiable {
    var id: Int {
            get { idpc }
            set { idpc = newValue }
        }
    var idpc: Int
    var idposte: Int
    var idcreneau: Int
    var idzonebenevole: Int
    var idfestival: Int
    var capacite: Int
    var capacite_restante: Int
    
    
    
    
    
    enum CodingKeys: String, CodingKey {
        case idpc = "idpc"
        case idposte
        case idcreneau
        case idzonebenevole
        case idfestival
        case capacite
        case capacite_restante
    }
}
