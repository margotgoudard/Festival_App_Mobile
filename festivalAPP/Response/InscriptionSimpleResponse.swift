//
//  InscriptionSimpleResponse.swift
//  FestivalAPP
//
//  Created by etud on 19/03/2024.
//

import Foundation
struct InscriptionSimpleResponse: Codable {
    let find : Bool
    let inscriptions: [InscriptionSimple]
}
