import SwiftUI

struct User: Codable {
var association: String
var est_vegetarien: Bool
var hebergement: String
var iduser: Int
var jeu_prefere: String
var mail: String
var mdp: String
var nom: String
var prenom: String
var pseudo: String
var taille_tshirt: String
var tel: String

enum CodingKeys: String, CodingKey {
    case association, est_vegetarien = "est_vegetarien", hebergement, iduser, jeu_prefere = "jeu_prefere", mail, mdp, nom, prenom, pseudo, taille_tshirt = "taille_tshirt", tel
}
}
