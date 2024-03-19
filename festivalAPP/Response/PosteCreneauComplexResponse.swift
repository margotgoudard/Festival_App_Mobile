//
//  PosteCreneauComplexResponse.swift
//  FestivalAPP
//
//  Created by etud on 15/03/2024.
//

import Foundation
struct PosteCreneauComplexResponse: Codable {
    let find: Bool
    let posteCreneau: [PosteCreneauComplexe]
        
    enum CodingKeys: String, CodingKey {
        case find
        case posteCreneau
    }
}
