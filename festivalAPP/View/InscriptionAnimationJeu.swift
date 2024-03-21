//
//  InscriptionAnimationJeu.swift
//  FestivalAPP
//
//  Created by etud on 20/03/2024.
//

import Foundation
import SwiftUI

struct InscriptionAnimationJeu: View {
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    let idUser = UserDefaults.standard.integer(forKey: "iduser")
    var festival: Festival
    var creneau : Creneau
    var listeZoneBenevole :[String: [EspaceAvecPosteCreneau]] = [:]
    
    init(festival: Festival, creneau : Creneau) {
        self.festival = festival
        self.creneau=creneau
        print("anim cr", creneau)
        var liste: [Espace] = []
        PlanningUtils.createListeZoneBenevole(token: token) { [self] espaces in
            liste = espaces
            liste.forEach { espace in
                print("espace   ", espace)
                PlanningUtils.sortListeZoneBenevole(idfestival: festival.id, idcreneau: creneau.id, idzonebenevole: espace.id, token: token){ sousespace in
                    print("sous espace        ", sousespace)
                    listeZoneBenevole[espace.nom]=sousespace
                }
                
            }
        }
       
    }
    
    
    var body: some View {
        
        VStack {
            // Demie page scrollable
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    // Vos éléments à afficher dans la moitié de la page scrollable
                    Text("Veuillez sélectionner une zone")
                }
                .padding()
            }
        }
        
       
    }
    
}
