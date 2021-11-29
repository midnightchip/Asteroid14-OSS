import Asteroid14C
import Cephei
import CoreTelephony
import SwiftUI

struct StatusBarSetup: View {
    @ObservedObject var prefs = AsteroidPrefs()
    let carrierName: String = {
        guard let providers = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders,
              let carrierName = providers.first?.value.carrierName
        else {
            return "Unknown"
        }

        return carrierName
    }()

    let weatherModel = WeatherModel.shared
    @State var moveToCompleted = false

    var body: some View {
        SetupTemplate {
            ZStack {
                WelcomeScreenAnimationView()
                Text("Status Bar")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }

        } explainView: {
            VStack {
                Text("Carrier Label")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Picker("Replace carrier text with current Temperature", selection: $prefs.statusCarrierContent) {
                    Text("Original").tag(0)
                    Text("Image").tag(1)
                    Text("Temperature").tag(2)
                    Text("Both").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                if prefs.statusCarrierContent > 0 {
                    Text("Replace carrier label with \(genRemainingText()).").font(.caption2).multilineTextAlignment(.center)
                }
                Spacer()
                Divider()
                Spacer()
                Text("Time Label")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Picker("Append weather conditions to time", selection: $prefs.statusInlineContent) {
                    Text("Original").tag(0)
                    Text("Image").tag(1)
                    Text("Temperature").tag(2)
                    Text("Both").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                if prefs.statusInlineContent > 0 {
                    Text("Append \(genRemainingText()) to then end of the time label.").font(.caption2).multilineTextAlignment(.center)
                }

                AsteroidSwitchCell(cellIsOn: $prefs.enableStatusTapTime, enableImage: true, imageName: "hand.tap.fill", labelText: "Tap to view conditions")
            }.padding(.horizontal)
        } actionView: {
            Button("Next") {
                moveToCompleted = true
            }
            .customButton()
            .padding(.horizontal)
            NavigationLink(destination: CompleteSetup(), isActive: $moveToCompleted) {
                EmptyView()
            }
        }
    }

    func genRemainingText() -> String {
        var remainingText = ""
        switch prefs.statusCarrierContent {
        case 0:
            remainingText = "Original"
        case 1:
            remainingText = "the current weather icon"
        case 2:
            remainingText = "the current temperature"
        case 3:
            remainingText = "the current weather icon and temperature"
        default:
            remainingText = ""
        }

        return remainingText
    }
}
