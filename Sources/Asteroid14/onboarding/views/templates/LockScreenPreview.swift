import Asteroid14C
import SwiftUI

struct LockScreenPreview: View {
    @ObservedObject var prefs = AsteroidPrefs()

    let weatherModel = WeatherModel.shared
    var body: some View {
        ZStack {
            Image(uiImage: getWallpaper(enableHome: false) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()

            AnimatedView(enableAnimation: $prefs.enableLockscreenAnimation, enableAnimationBackground: $prefs.enableLockscreenAnimationBackground, enableCustomLocation: $prefs.enableCustomLocationLockscreen, enableCustomCondition: $prefs.enableCustomConditionLockscreen, useNightCondition: $prefs.enableNightConditionLockscreen, customLocationIndex: $prefs.lockScreenLocationIndex, customConditionIndex: $prefs.lockScreenConditionIndex)
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    ClockView()

                    if prefs.appEnableWeatherGlyph {
                        HStack {
                            Spacer()
                            Image(uiImage: weatherModel.glyph() ?? UIImage())
                            Spacer()
                        }
                    }
                }.padding(.top, 15)

                Spacer()
                Spacer()
                ForecastTextView(forecastText: weatherModel.currentConditionOverview())
                    .padding(.top)
                    .padding(.horizontal)
                    .opacity(prefs.enableLockscreenText ? 1 : 0)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        }
    }
}
