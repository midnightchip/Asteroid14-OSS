import Asteroid14C
import Cephei
import SwiftUI

struct HomeScreenPreview: View {
    @ObservedObject var prefs = AsteroidPrefs()
    private let weatherModel = WeatherModel.shared
    private let threeColumnGrid = [GridItem(.flexible(minimum: 60, maximum: 60), spacing: 20), GridItem(.flexible(minimum: 60, maximum: 60), spacing: 20), GridItem(.flexible(minimum: 60, maximum: 60), spacing: 20), GridItem(.flexible(minimum: 60, maximum: 60), spacing: 20)]

    var body: some View {
        ZStack {
            Image(uiImage: getWallpaper(enableHome: true) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()

            AnimatedView(enableAnimation: $prefs.enableHomeScreenAnimation, enableAnimationBackground: $prefs.enableHomeScreenAnimationBackground, enableCustomLocation: $prefs.enableHomeCustomLocation, enableCustomCondition: $prefs.enableHomeCustomCondition, useNightCondition: $prefs.enableNightConditionHomeScreen, customLocationIndex: $prefs.homeScreenLocationIndex, customConditionIndex: $prefs.homeScreenConditionIndex)
            if prefs.appEnableHook {
                ScrollView {
                    LazyVGrid(columns: threeColumnGrid, spacing: 20) {
                        ForEach(prefs.appSelectedIds, id: \.self) { bundleID in
                            ZStack {
                                Image(uiImage: UIImage._applicationIconImage(forBundleIdentifier: bundleID, format: 1, scale: 4.0).resize(toHeight: 60)).frame(width: 60, height: 60)
                                AnimatedView(enableAnimation: $prefs.appEnableAnimation, enableAnimationBackground: $prefs.appEnableAnimationBackground, enableCustomLocation: $prefs.appEnableCustomLocation, enableCustomCondition: $prefs.appEnableCustomLocation, useNightCondition: $prefs.appEnableLocationNight, customLocationIndex: $prefs.appLocationIndex, customConditionIndex: $prefs.appCustomConditionIndex)
                                    .overlay(
                                        VStack {
                                            Spacer()
                                            Image(uiImage: weatherModel.glyph()!).opacity(prefs.appEnableWeatherGlyph ? 1 : 0).padding(.top)
                                            Text(weatherModel.localeTemperature()).opacity(prefs.appEnableTemperature ? 1 : 0).padding(.bottom)
                                            Spacer()
                                        }
                                    )

                            }.frame(width: 60, height: 60)
                        }.cornerRadius(15)
                    }.padding(.top)
                }
                .frame(width: UIScreen.main.bounds.width)
            }
        }
    }
}
