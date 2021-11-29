import SwiftUI

struct AsteroidSwitchCell: View {
    @Binding var cellIsOn: Bool
    let enableImage: Bool
    let imageName: String
    let labelText: String

    var body: some View {
        HStack {
            if enableImage {
                Image(systemName: imageName)
                Spacer()
            }
            Toggle(isOn: $cellIsOn.animation()) {
                Text(labelText)
            }
        }.padding()
    }
}
