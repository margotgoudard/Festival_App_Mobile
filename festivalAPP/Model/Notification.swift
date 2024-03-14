//
//  Notification.swift
//  FestivalAPP
//
//  Created by etud on 14/03/2024.
//

import Foundation
import SwiftUI

struct Notification: Codable, Identifiable, Hashable {
    var id: Int {
            get { idnotification }
            set { idnotification = newValue }
        }
    var idnotification: Int
    var label: String
    var iduser: Int
    var idfestival: Int
    
    
    enum CodingKeys: String, CodingKey {
        case idnotification = "idnotification"
        case label
        case iduser
        case idfestival
    }
}
