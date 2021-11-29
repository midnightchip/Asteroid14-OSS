import asteroidpreferencesC
import Cephei
import Orion

let APP_LOCATION_INDEX = "AppLocationIndex"
let APP_CUSTOM_CONDITION_INDEX = "AppCustomConditionIndex"
let APP_ENABLE_ANIMATION = "AppEnableAnimation"
let APP_ENABLE_LOCATION_NIGHT = "AppEnableLocationNight"
let APP_ENABLE_CUSTOM_CONDITION = "AppEnableCustomCondition"
let APP_ENABLE_CUSTOM_LOCATION = "AppEnableCustomLocation"
let APP_ENABLE_ANIMATION_BACKGROUND = "AppEnableAnimationBackground"
let APP_ENABLE_WEATHER_GLYPH = "AppEnableWeatherGlyph"
let APP_ENABLE_TEMPERATURE = "AppEnableTemperature"

class LiveWeatherIconPreview: UIView {
    let prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    var referenceView: WUIWeatherConditionBackgroundView?
    var weatherPreferences = WeatherPreferences.shared()
    let allCities: [City] = WeatherPreferences.shared().loadSavedCities()
    var setup = false
    var tempLabel: UILabel?
    var gradientView: UIView?
    var logo: UIImageView?
    var gradientLayer: CAGradientLayer?

    var cityIndex: Int = 0
    var customConditionIndex: Int = 0
    var enableWeatherAnimation = false
    var isNight = false
    var customConditionEnabled = false
    var customLocationIndexEnabled = false
    var enableBackground = false
    var enableWeatherGlyph = false
    var enableTemperatureLabel = false
    var enableGradientLayer = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPrefs()
        backgroundColor = UIColor.clear
        clipsToBounds = true
        updateWeatherDisplay()
        // delayWithSeconds(2, completion: { self.updateWeatherDisplay() })
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    func setupPrefs() {
        cityIndex = prefs.integer(forKey: APP_LOCATION_INDEX, default: 0)
        customConditionIndex = prefs.integer(forKey: APP_CUSTOM_CONDITION_INDEX, default: 0)
        enableWeatherAnimation = prefs.bool(forKey: APP_ENABLE_ANIMATION, default: false)
        isNight = prefs.bool(forKey: APP_ENABLE_LOCATION_NIGHT, default: false)
        customConditionEnabled = prefs.bool(forKey: APP_ENABLE_CUSTOM_CONDITION, default: false)
        customLocationIndexEnabled = prefs.bool(forKey: APP_ENABLE_CUSTOM_LOCATION, default: false)
        enableBackground = prefs.bool(forKey: APP_ENABLE_ANIMATION_BACKGROUND, default: false)
        enableWeatherGlyph = prefs.bool(forKey: APP_ENABLE_WEATHER_GLYPH, default: false)
        enableTemperatureLabel = prefs.bool(forKey: APP_ENABLE_TEMPERATURE, default: false)
    }

    @objc func updateWeatherDisplay() {
        if !setup {
            if enableWeatherAnimation {
                setupReferenceView()
            }
            if enableTemperatureLabel {
                setupTempLabel()
            } else {
                tempLabel?.removeFromSuperview()
                tempLabel = nil
            }
            if enableWeatherGlyph {
                setupLogoView()
            } else {
                logo?.removeFromSuperview()
                logo = nil
            }
            setup = true
        }

        if enableBackground {
            setupGradientView()
            let tempView = createConditionBackgroundView()
            gradientLayer = tempView?.background().gradientLayer // gradient(weatherGradient: tempView?.background().gradientLayer)
            gradientLayer?.frame = gradientView?.frame ?? CGRect.zero
            gradientView?.layer.sublayers?.removeAll()
            gradientView?.layer.insertSublayer(gradientLayer!, at: 0)
        } else {
            if gradientLayer != nil {
                gradientLayer?.removeFromSuperlayer()
                gradientLayer = nil
            }
        }

        if tempLabel?.bounds == CGRect(x: 0, y: 0, width: 0, height: 0), enableTemperatureLabel {
            setupTempLabel()
        }

        if logo?.bounds == CGRect(x: 0, y: 0, width: 0, height: 0), enableWeatherGlyph {
            setupLogoView()
        }

        if enableTemperatureLabel {
            UIView.transition(with: tempLabel!,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.tempLabel!.text = self.localeTemperature() },
                              completion: nil)

            tempLabel!.layoutSubviews()
        }

        if enableWeatherGlyph {
            var city: City
            if customLocationIndexEnabled {
                city = allCities[cityIndex]
            } else {
                city = allCities[0]
            }
            if let icon = WeatherImageLoader.conditionImage(withConditionIndex: Int(city.conditionCode)) {
                UIView.transition(with: logo!,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: { self.logo!.image = icon },
                                  completion: nil)
            }
            logo!.layoutSubviews()
        }

        layoutSubviews()
    }

    func localeTemperature() -> String {
        var city: City
        if customLocationIndexEnabled {
            city = allCities[cityIndex]
        } else {
            city = allCities[0]
        }
        guard let temp = weatherPreferences?.isCelsius() ?? false ? city.temperature()?.celsius : city.temperature()?.fahrenheit else {
            return "--"
        }
        return "\(temp)°"
    }

    func updateSize(_ size: CGSize) {
        if frame.size != size {
            frame.size = size
            updateWeatherDisplay()
        }
    }

    func setupTempLabel() {
        if tempLabel != nil {
            tempLabel?.removeFromSuperview()
        }
        tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        tempLabel?.font = UIFont.systemFont(ofSize: 15.00, weight: .semibold)

        tempLabel?.textColor = UIColor.white
        tempLabel?.textAlignment = NSTextAlignment.center
        tempLabel?.center = CGPoint(x: frame.size.width / 1.9, y: frame.size.height / 1.3)
        addSubview(tempLabel!)
    }

    func setupLogoView() {
        if logo != nil {
            logo?.removeFromSuperview()
        }
        logo = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width / 1.5, height: frame.size.height / 1.5))
        logo?.contentMode = ContentMode.scaleAspectFit
        logo?.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2.5)
        if logo != nil {
            addSubview(logo!)

            logo!.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
            logo!.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
            logo!.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
            logo!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true
        }
    }

    func setupReferenceView() {
        if referenceView != nil {
            referenceView?.removeFromSuperview()
        }
        referenceView = createConditionBackgroundView()

        referenceView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        referenceView?.clipsToBounds = true
        referenceView?.background().gradientLayer.isHidden = true
        // [[_weatherView background] gradientLayer].hidden = !enableBackground;
        if referenceView != nil {
            addSubview(referenceView!)
            sendSubviewToBack(referenceView!)
            referenceView!.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
            referenceView!.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
            referenceView!.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
            referenceView!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true
        }
    }

    func setupGradientView() {
        if gradientView != nil {
            gradientView?.removeFromSuperview()
        }

        gradientView = UIView(frame: bounds)
        gradientView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gradientView?.clipsToBounds = true

        if gradientView != nil {
            addSubview(gradientView!)
            sendSubviewToBack(gradientView!)
            gradientView!.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            gradientView!.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            gradientView!.topAnchor.constraint(equalTo: topAnchor).isActive = true
            gradientView!.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }

    func createConditionBackgroundView() -> WUIWeatherConditionBackgroundView? {
        let view = WUIWeatherConditionBackgroundView(frame: frame)

        var targetCity: City
        if customLocationIndexEnabled {
            targetCity = allCities[cityIndex].cityCopy()
        } else if customConditionEnabled {
            targetCity = allCities[0].cityCopy()
            targetCity.conditionCode = Int64(customConditionIndex)
            if isNight && targetCity.isDay || !isNight && !targetCity.isDay {
                let currentDiff = targetCity.timeZone.secondsFromGMT()
                targetCity.timeZone = TimeZone(secondsFromGMT: currentDiff + 43200)
            }
        } else {
            targetCity = allCities[0].cityCopy()
        }

        view?.background()?.setCity(targetCity)

        if customConditionEnabled, isNight {
            view?.background()?.condition().forcesNight = 1
        }

        return view
    }
}
