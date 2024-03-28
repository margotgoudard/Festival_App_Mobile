import SwiftUI

struct FestivalAvisEditorView: View {
    @Binding var avis: String
    var onAvisSubmit: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Laissez un avis sur le festival :")
                .font(.headline)
                .padding(.top, 20)
            TextEditor(text: $avis)
                .frame(height: 150)
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal, 20)
            
            Button(action: onAvisSubmit) {
                Text("Soumettre l'avis")
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
        .background(Color(UIColor.systemGroupedBackground))
        .cornerRadius(12)
        .padding(.horizontal, 10) 
    }
}
