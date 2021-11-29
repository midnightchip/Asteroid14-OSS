import Asteroid14C
import Cephei
import SwiftUI

struct LockScreenSetup: View {
    // let prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    let weatherModel = WeatherModel.shared
    @ObservedObject var prefs = AsteroidPrefs()

    @State var showSelectLocation: Bool = false
    @State var showSelectCondition: Bool = false
    @State var moveToHomeScreen: Bool = false

    var body: some View {
        SetupTemplate {
            LockScreenPreview()
        } explainView: {
            VStack {
                HStack {
                    Text("Lockscreen")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width)
                .background(Color(UIColor.systemBackground))

                Divider()

                AsteroidSwitchCell(cellIsOn: $prefs.enableLockscreenAnimation, enableImage: true, imageName: "cloud.sun.fill", labelText: "Enable Weather Animation")

                if prefs.enableLockscreenAnimation {
                    AsteroidSwitchCell(cellIsOn: $prefs.enableLockscreenAnimationBackground, enableImage: true, imageName: "rectangle.dashed", labelText: "Enable Background Gradient")

                    if !prefs.enableCustomConditionLockscreen {
                        AsteroidSwitchCell(cellIsOn: $prefs.enableCustomLocationLockscreen, enableImage: true, imageName: "location.viewfinder", labelText: "Enable Custom Location")
                    }

                    if prefs.enableCustomLocationLockscreen {
                        Button(action: {
                            showSelectLocation.toggle()
                        }) {
                            Text("Select Custom Location")
                        }.padding()
                    } else {
                        AsteroidSwitchCell(cellIsOn: $prefs.enableCustomConditionLockscreen, enableImage: true, imageName: "sparkles", labelText: "Enable Custom Condition")

                        if prefs.enableCustomConditionLockscreen {
                            AsteroidSwitchCell(cellIsOn: $prefs.enableNightConditionLockscreen, enableImage: true, imageName: "moon.fill", labelText: "Use Night Conditions")

                            Button(action: {
                                showSelectCondition.toggle()

                            }) {
                                Text("Select Custom Condition")
                            }.padding()
                        }
                    }
                }
                Divider()
                Spacer()

                AsteroidSwitchCell(cellIsOn: $prefs.appEnableWeatherGlyph, enableImage: true, imageName: "clock.fill", labelText: "Enable Weather Icon Under Time")

                Divider()
                Spacer()

                AsteroidSwitchCell(cellIsOn: $prefs.enableLockscreenText, enableImage: true, imageName: "character.textbox", labelText: "Enable Forecast on Welcome Text")
            }
        } actionView: {
            Button("Next") {
                moveToHomeScreen.toggle()
            }
            .customButton()
            .padding(.horizontal)
            NavigationLink(destination: HomeScreenSetup(), isActive: $moveToHomeScreen) {
                EmptyView()
            }
        }.sheet(isPresented: $showSelectCondition, onDismiss: {
        }, content: {
            ConditionSelector(selectedIndex: $prefs.lockScreenConditionIndex, presented: $showSelectCondition, isNight: $prefs.enableNightConditionLockscreen)
        })
        .sheet(isPresented: $showSelectLocation, onDismiss: {
            self.prefs.objectWillChange.send()
        }, content: {
            LocationSelector(selectedIndex: $prefs.lockScreenLocationIndex, presented: $showSelectLocation)
        })
    }
}
