import Asteroid14C
import SwiftUI

struct WelcomeScreenAnimationView: UIViewRepresentable {
    let weatherModel = WeatherModel.shared
    func updateUIView(_: UIViewType, context _: Context) {}

    func makeUIView(context _: Context) -> some UIView {
        let bgView = WUIWeatherConditionBackgroundView()
        let targetCity = weatherModel.city?.cityCopy() ?? City()
        targetCity.conditionCode = 0 + Int64(arc4random_uniform(47 - 1))
        bgView.background().setCity(targetCity)

        NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: .main, using: { _ in
            WUIDynamicWeatherBackground.handleMemoryWarning()
            MCLogger.log("Receieved Memory Warning")
        })

        return bgView
    }
}

struct LocationSelectionAnimationView: UIViewRepresentable {
    let currentCity: City?
    func updateUIView(_: UIViewType, context _: Context) {}

    func makeUIView(context _: Context) -> some UIView {
        let bgView = WUIWeatherConditionBackgroundView()
        if currentCity?.conditionCode == nil {
            currentCity?.conditionCode = 0 + Int64(arc4random_uniform(47 - 1))
        }
        bgView.background().setCity(currentCity)
        return bgView
    }
}

struct ClockView: UIViewRepresentable {
    func updateUIView(_: SBFLockScreenDateView, context _: Context) {}

    func makeUIView(context _: Context) -> SBFLockScreenDateView {
        let clock = SBFLockScreenDateView()
        clock.setDate(Date())
        return clock
    }
}

struct ForecastTextView: UIViewRepresentable {
    let forecastText: String
    func updateUIView(_: SBUICallToActionLabel, context _: Context) {}

    func makeUIView(context _: Context) -> SBUICallToActionLabel {
        let label = SBUICallToActionLabel()
        label.setText(forecastText)
        return label
    }
}

struct CustomConditionPreview: UIViewRepresentable {
    let conditionCode: Int
    let isNight: Bool
    let weatherModel = WeatherModel.shared

    func updateUIView(_: UIViewType, context _: Context) {}

    func makeUIView(context _: Context) -> some UIView {
        let bgView = WUIWeatherConditionBackgroundView()
        let targetCity = weatherModel.city?.cityCopy() ?? City()
        targetCity.conditionCode = Int64(conditionCode)

        if targetCity.isDay, isNight {
            let timeDifference = Int64(targetCity.sunsetTime) - Int64(targetCity.observationTime)
            if timeDifference > 0 {
                targetCity.observationTime = (targetCity.sunsetTime) + 30
                let currentTimeOffset = targetCity.timeZone?.secondsFromGMT() ?? 0
                targetCity.timeZone = TimeZone(secondsFromGMT: currentTimeOffset + Int(formatTime(offset: timeDifference)))
            }
        } else if !targetCity.isDay, !isNight {
            let timeDifference = Int64(targetCity.sunsetTime) - Int64(targetCity.observationTime)
            if timeDifference > 0 {
                targetCity.observationTime = (targetCity.sunsetTime) + 30
                let currentTimeOffset = targetCity.timeZone?.secondsFromGMT() ?? 0
                targetCity.timeZone = TimeZone(secondsFromGMT: currentTimeOffset + Int(formatTime(offset: timeDifference)))
            }
        }
        bgView.background().setCity(targetCity)

        if isNight {
            bgView.background()?.condition()?.forcesNight = 1
        }

        return bgView
    }
}

struct AnimatedView: UIViewRepresentable {
    @Binding var enableAnimation: Bool
    @Binding var enableAnimationBackground: Bool
    @Binding var enableCustomLocation: Bool
    @Binding var enableCustomCondition: Bool
    @Binding var useNightCondition: Bool
    @Binding var customLocationIndex: Int
    @Binding var customConditionIndex: Int

    let weatherModel = WeatherModel.shared
    func updateUIView(_ weatherView: WUIWeatherConditionBackgroundView, context _: Context) {
        MCLogger.log("Updating View")
        // DispatchQueue.main.async {
        updateWeatherView(weatherView: weatherView)
        // }
    }

    func makeUIView(context _: Context) -> WUIWeatherConditionBackgroundView {
        let weatherView = WUIWeatherConditionBackgroundView()
        updateWeatherView(weatherView: weatherView)
        return weatherView
    }

    func setCity(completion: @escaping (_ city: City?) -> Void) {
        var backgroundCity: City?
        if enableCustomLocation {
            backgroundCity = weatherModel.getCityAtIndex(customLocationIndex)
        } else if enableCustomCondition {
            backgroundCity = weatherModel.city?.cityCopy()
            backgroundCity?.conditionCode = Int64(customConditionIndex)
            if backgroundCity?.isDay ?? false, useNightCondition {
                let timeDifference = Int64(backgroundCity?.sunsetTime ?? 0) - Int64(backgroundCity?.observationTime ?? 0)
                if timeDifference > 0 {
                    backgroundCity?.observationTime = (backgroundCity?.sunsetTime ?? 0) + 30
                    let currentTimeOffset = backgroundCity?.timeZone?.secondsFromGMT() ?? 0
                    backgroundCity?.timeZone = TimeZone(secondsFromGMT: currentTimeOffset + Int(formatTime(offset: timeDifference)))
                }
            } else if !(backgroundCity?.isDay ?? false), !useNightCondition {
                let timeDifference = Int64(backgroundCity?.sunsetTime ?? 0) - Int64(backgroundCity?.observationTime ?? 0)
                if timeDifference > 0 {
                    backgroundCity?.observationTime = (backgroundCity?.sunsetTime ?? 0) + 30
                    let currentTimeOffset = backgroundCity?.timeZone?.secondsFromGMT() ?? 0
                    backgroundCity?.timeZone = TimeZone(secondsFromGMT: currentTimeOffset + Int(formatTime(offset: timeDifference)))
                }
            }
        } else {
            backgroundCity = weatherModel.city // city
        }

        completion(backgroundCity)
    }

    func cloneCity(oldCity: City) -> City {
        let newCity = City()
        newCity.name = oldCity.name
        newCity.sunriseTime = oldCity.sunriseTime
        newCity.sunsetTime = oldCity.sunsetTime
        newCity.observationTime = oldCity.observationTime
        newCity.conditionCode = oldCity.conditionCode
        newCity.isDay = oldCity.isDay
        newCity.timeZone = oldCity.timeZone
        newCity.isLocalWeatherCity = oldCity.isLocalWeatherCity
        return newCity
    }

    func updateWeatherView(weatherView: WUIWeatherConditionBackgroundView) {
        setCity { city in
            if let city = city {
                weatherView.background().setCity(city, animate: true)
                weatherView.isHidden = !enableAnimation

                if useNightCondition {
                    weatherView.background()?.condition()?.forcesNight = 1
                }

                weatherView.background()?.gradientLayer.isHidden = !enableAnimationBackground
            }
        }
    }
}

struct ApplicationSelector: UIViewControllerRepresentable {
    func makeUIViewController(context _: UIViewControllerRepresentableContext<ApplicationSelector>) -> ATLApplicationListMultiSelectionController {
        let picker = ATLApplicationListMultiSelectionController()
        let newSpec = PSSpecifier.preferenceSpecifierNamed("ClicMe", target: picker, set: #selector(picker.setPreferenceValue(_:specifier:)), get: #selector(picker.readPreferenceValue(_:)), detail: nil, cell: PSCellType.buttonCell, edit: nil)
        newSpec?.setProperty("me.midnightchips.asteroidpreferences", forKey: "defaults")
        newSpec?.setProperty("SelectedLiveWeatherApps", forKey: "key")
        newSpec?.setProperty(true, forKey: "showIdentifiersAsSubtitle")
        newSpec?.setProperty(true, forKey: "useSearchBar")
        newSpec?.setProperty([
            [
                "sectionType": "Visible",
            ],
        ], forKey: "sections")
        picker.specifier = newSpec

        return picker
    }

    func updateUIViewController(_: ATLApplicationListMultiSelectionController, context _: UIViewControllerRepresentableContext<ApplicationSelector>) {}
}
