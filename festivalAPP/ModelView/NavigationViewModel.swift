import SwiftUI

class NavigationViewModel: ObservableObject {
    @Published var showListePosteView: Bool = false
    @Published var showPosteDetailView: Bool = false
}
