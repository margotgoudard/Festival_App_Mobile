//
//  FlexibleUserCreneau.swift
//  FestivalAPP
//
//  Created by etud on 18/03/2024.
//

import Foundation
import SwiftUI

struct FlexibleUserCreneau: Codable, Identifiable {
    var id: Int
    var idcreneau: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "iduser"
        case idcreneau
        
    }
}
