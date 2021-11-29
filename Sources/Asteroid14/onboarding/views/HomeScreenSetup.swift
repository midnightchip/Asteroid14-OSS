import Asteroid14C
import Cephei
import SwiftUI

struct HomeScreenSetup: View {
    @ObservedObject var prefs = AsteroidPrefs()
    let weatherModel = WeatherModel.shared

    @State var showSelectLocation: Bool = false
    @State var showSelectCondition: Bool = false
    @State var showApplicationSelector: Bool = false
    @State var moveToStatusBar: Bool = false
    var body: some View {
        SetupTemplate {
            HomeScreenPreview()
        } explainView: {
            VStack {
                HStack {
                    Text("Homescreen")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width)
                .background(Color(UIColor.systemBackground))

                Divider()

                AsteroidSwitchCell(cellIsOn: $prefs.enableHomeScreenAnimation, enableImage: true, imageName: "cloud.sun.fill", labelText: "Enable Weather Animation")

                if prefs.enableHomeScreenAnimation {
                    AsteroidSwitchCell(cellIsOn: $prefs.enableHomeScreenAnimationBackground, enableImage: true, imageName: "rectangle.dashed", labelText: "Enable Background Gradient")

                    if !prefs.enableHomeCustomCondition {
                        AsteroidSwitchCell(cellIsOn: $prefs.enableHomeCustomLocation, enableImage: true, imageName: "location.viewfinder", labelText: "Enable Custom Location")
                    }

                    if prefs.enableHomeCustomLocation {
                        Button(action: {
                            showSelectLocation.toggle()
                        }) {
                            Text("Select Custom Location")
                        }.padding()
                    } else {
                        AsteroidSwitchCell(cellIsOn: $prefs.enableHomeCustomCondition, enableImage: true, imageName: "sparkles", labelText: "Enable Custom Condition")

                        if prefs.enableHomeCustomCondition {
                            AsteroidSwitchCell(cellIsOn: $prefs.enableNightConditionHomeScreen, enableImage: true, imageName: "moon.fill", labelText: "Use Night Conditions")

                            Button(action: {
                                showSelectCondition.toggle()

                            }) {
                                Text("Select Custom Condition")
                            }.padding()
                        }
                    }
                }
                Divider()

                AsteroidSwitchCell(cellIsOn: $prefs.appEnableHook, enableImage: true, imageName: "app.badge.fill", labelText: "Enable Live Weather App Icons")
                if prefs.appEnableHook {
                    Button(action: {
                        showApplicationSelector.toggle()
                    }) {
                        VStack {
                            Text("Select Applications")
                        }

                    }.padding()

                    AsteroidSwitchCell(cellIsOn: $prefs.appEnableWeatherGlyph, enableImage: true, imageName: "sparkles", labelText: "Enable Weather Icon")
                    AsteroidSwitchCell(cellIsOn: $prefs.appEnableTemperature, enableImage: true, imageName: "thermometer", labelText: "Enable Temperature")

                    AsteroidSwitchCell(cellIsOn: $prefs.appEnableAnimation, enableImage: true, imageName: "rectangle.dashed", labelText: "Enable Weather Animation")
                    if prefs.appEnableAnimation {
                        AsteroidSwitchCell(cellIsOn: $prefs.appEnableAnimationBackground, enableImage: true, imageName: "rectangle.dashed", labelText: "Enable Background Gradient")
                        if !prefs.appEnableCustomCondition {
                            AsteroidSwitchCell(cellIsOn: $prefs.appEnableCustomLocation, enableImage: true, imageName: "location.viewfinder", labelText: "Enable Custom Location")
                        }

                        if prefs.appEnableCustomLocation {
                            Button(action: {
                                showSelectLocation.toggle()
                            }) {
                                Text("Select Custom Location")
                            }.padding()
                        } else {
                            AsteroidSwitchCell(cellIsOn: $prefs.appEnableCustomCondition, enableImage: true, imageName: "sparkles", labelText: "Enable Custom Condition")

                            if prefs.appEnableCustomCondition {
                                AsteroidSwitchCell(cellIsOn: $prefs.appEnableLocationNight, enableImage: true, imageName: "moon.fill", labelText: "Use Night Conditions")

                                Button(action: {
                                    showSelectCondition.toggle()

                                }) {
                                    Text("Select Custom Condition")
                                }.padding()
                            }
                        }
                    }
                }
            }
        } actionView: {
            Button("Next") {
                moveToStatusBar.toggle()
            }
            .customButton()
            .padding(.horizontal)
            NavigationLink(destination: StatusBarSetup(), isActive: $moveToStatusBar) {
                EmptyView()
            }
        }.sheet(isPresented: $showSelectCondition, content: {
            ConditionSelector(selectedIndex: $prefs.homeScreenConditionIndex, presented: $showSelectCondition, isNight: $prefs.enableNightConditionHomeScreen)
        })
        .sheet(isPresented: $showSelectLocation, content: {
            LocationSelector(selectedIndex: $prefs.homeScreenLocationIndex, presented: $showSelectLocation)
        })
        .sheet(isPresented: $showApplicationSelector, onDismiss: {
            self.prefs.objectWillChange.send()
        }) {
            ApplicationSelector()
        }
    }
}
