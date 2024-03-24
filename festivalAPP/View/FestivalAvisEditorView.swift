import SwiftUI

struct FestivalAvisEditorView: View {
    @Binding var avis: String
    var onAvisSubmit: () -> Void
    
    var body: some View {
        VStack(spacing: 16) { // Adjusted for more spacing
            Text("Laissez un avis sur le festival :")
                .font(.headline)
                .padding(.top, 20) // Increased padding at the top for more headroom
            
            TextEditor(text: $avis)
                .frame(height: 150) // Increased height for more writing space
                .padding(4) // Padding inside the TextEditor
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1)) // Rounded corners for the TextEditor
                .padding(.horizontal, 20) // Horizontal padding for the TextEditor
            
            Button(action: onAvisSubmit) {
                Text("Soumettre l'avis")
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity) // Make the button width fill the container
                    .padding() // Padding inside the button
                    .background(Color.blue) // Background color of the button
                    .cornerRadius(10) // Rounded corners for the button
            }
            .buttonStyle(.borderedProminent) // Use the prominent bordered button style
            .padding(.horizontal, 20) // Horizontal padding for the button
        }
        .padding(.bottom, 20) // Padding at the bottom of the VStack
        .background(Color(UIColor.systemGroupedBackground)) // Use system background color
        .cornerRadius(12) // Rounded corners for the entire VStack
        .padding(.horizontal, 10) // Slight padding from the screen edges
    }
}
