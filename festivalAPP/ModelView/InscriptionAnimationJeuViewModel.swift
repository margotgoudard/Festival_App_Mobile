import Foundation
import SwiftUI

class InscriptionAnimationJeuViewModel: ObservableObject {
    @Published var listeZoneBenevole: [String: [EspaceAvecPosteCreneau]] = [:]
    @Published var isLoading = true
    @Published var selectedZone: EspaceAvecPosteCreneau? // Add this line

    func fetchListeZoneBenevole(festival: Festival, creneau: Creneau) {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        var liste: [Espace] = []
        var listeZoneBenevoleTemps: [String: [EspaceAvecPosteCreneau]] = [:]

        PlanningUtils.createListeZoneBenevole(token: token) { [weak self] espaces in
            guard let self = self else { return }
            liste = espaces
            var count = 0
            var sortedTemp = [String: [EspaceAvecPosteCreneau]]()
            for espace in liste {
                PlanningUtils.sortListeZoneBenevole(idfestival: festival.id, idcreneau: creneau.id, idzonebenevole: espace.id, token: token) { sousespace in
                    if sousespace.count > 0 {
                        var filteredSubspace = sousespace
                        if sousespace.count > 1 {
                            filteredSubspace = sousespace.filter { $0.nom != espace.nom }
                        }
                         
                        listeZoneBenevoleTemps[espace.nom] = filteredSubspace
                    }
                    count += 1
                    // Verify all requests are finished before sorting and assigning listeZoneBenevole
                    if count == liste.count {
                        let sortedKeys = listeZoneBenevoleTemps.keys.sorted()
                        for key in sortedKeys {
                            sortedTemp[key] = listeZoneBenevoleTemps[key]
                        }
                        DispatchQueue.main.async {
                            self.listeZoneBenevole = sortedTemp
                            self.isLoading = false
                            // Initialize selectedZone with the first subzone of the first zone, if available
                            if let firstZoneKey = self.listeZoneBenevole.keys.sorted().first,
                               let firstSubZone = self.listeZoneBenevole[firstZoneKey]?.first {
                                self.selectedZone = firstSubZone
                            }
                        }
                    }
                }
            }
        }
    }
}
