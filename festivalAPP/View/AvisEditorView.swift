import SwiftUI

struct AvisEditorView: View {
    @Binding var texteAvisEnEdition: String
    var onValider: () -> Void
    var onAnnuler: () -> Void
    
    var body: some View {
        HStack {
            TextField("Votre avis", text: $texteAvisEnEdition)
                .textFieldStyle(.roundedBorder)
            Button("Valider", action: onValider)
            Button("Annuler", action: onAnnuler)
        }
    }
}

