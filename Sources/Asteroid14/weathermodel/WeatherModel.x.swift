import Asteroid14C
import Orion
import os

@objcMembers @objc(AWeatherModel) class WeatherModel: NSObject, CityUpdateObserver, WATodayModelObserver {
    static let shared = WeatherModel()
    var weatherPreferences = WeatherPreferences.shared()
    let cityUpdater = TWCLocationUpdater.shared()
    var todayModel: WATodayAutoupdatingLocationModel?
    var forecastModel: WAForecastModel?
    var city: City?
    var allCities: [City]?
    var refreshTimer: Timer?
    var weatherBundle: Bundle?
    private var updatingModel: Bool = false
    let backgroundThread = DispatchQueue(label: "AsteroidQueue", qos: .background)

    override private init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(updateModel(_:)), name: Notification.Name(rawValue: "UpdateWeatherModel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(memWarning(_:)), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        backgroundThread.async {
            self.configureWeather()
        }
    }

    func updateModel(_: Notification) {
        backgroundThread.async {
            self.updateModel()
        }
    }

    func memWarning(_: Notification) {
        DispatchQueue.main.async {
            WUIDynamicWeatherBackground.handleMemoryWarning()
        }
    }

    // TODO: recall this when needed
    func configureWeather(completion _: (() -> Void)? = nil) {
        // Rather than setting entitlements, lets just pretend to be something with the proper entitlements
        // DispatchQueue.global(qos: .background).async {
        todayModel = WATodayModel.autoupdatingLocationModel(withPreferences: WeatherPreferences(), effectiveBundleIdentifier: "com.apple.locationd.bundle-/System/Library/LocationBundles/CompassCalibration.bundle") as? WATodayAutoupdatingLocationModel
        todayModel?.addObserver(self)
        let fallbackCity = City()
        fallbackCity.conditionCode = 32
        if weatherPreferences?.isLocalWeatherEnabled ?? false, weatherPreferences?.localWeatherCity != nil {
            // updatingModel = true
            // updateModel()
            allCities = weatherPreferences?.loadSavedCities()
            if city?.name == nil {
                if allCities?.isEmpty ?? false {
                    city = allCities?[0] ?? fallbackCity
                } else {
                    city = fallbackCity
                }
            }
        } else {
            allCities = weatherPreferences?.loadSavedCities()
            if allCities?.isEmpty ?? false {
                city = allCities?[0] ?? fallbackCity
            } else {
                city = fallbackCity
            }
        }
        // Set the Auto Update Timer
        refreshTimer = Timer.scheduledTimer(timeInterval: Double(city?.updateInterval ?? 300), target: self, selector: #selector(updateCityWeather(sender:)), userInfo: nil, repeats: true)
        // Trigger first update
        updateCityWeather()
        // }
    }

    func getCityAtIndex(_ index: Int) -> City {
        let fallbackCity = City()
        fallbackCity.conditionCode = 32
        if !(allCities?.isEmpty ?? false) {
            return allCities?[index] ?? fallbackCity
        } else {
            return fallbackCity
        }
    }

    func updateCityWeather() {
        cityUpdater?.updateWeather(forCities: allCities, withCompletionHandler: { data, error in
            MCLogger.log("Handler Ran! \(type(of: data)) \(type(of: error))")
        })
    }

    // com.apple.weather.widget
    func updateModel() {
        todayModel?.locationManager.locationManager.requestAlwaysAuthorization()
        todayModel?.setLocationServicesActive(true)
        todayModel?.isLocationTrackingEnabled = true
        todayModel?.executeUpdate(completion: { _, _ in
            self.updatingModel = false
            DispatchQueue.main.async {
                MCLogger.log("Updating Weather Model!")
                self.city = self.todayModel?.forecastModel().city
            }
        })
    }

    func getAuthStatus(bundleId: String) -> Bool {
        return CLLocationManager.convertAuthStatus(toBool: CLLocationManager._authorizationStatus(forBundleIdentifier: bundleId, bundle: nil))
    }

    func updateCityWeather(sender _: Timer) {
        MCLogger.log("Running timed update")
        updateCityWeather()
        updateModel()
    }

    func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(ASTEROID_WEATHER_UPDATE), object: nil)
    }

    func localeTemperature() -> String {
        guard let temp = weatherPreferences?.isCelsius() ?? false ? city?.temperature()?.celsius : city?.temperature()?.fahrenheit else {
            return "--"
        }
        return "\(Int(temp))°"
    }

    func currentConditionOverview() -> String {
        return city?.naturalLanguageDescription() ?? "Weather Unavailable"
    }

    func glyph() -> UIImage? {
        let hourlyForcast = city?.hourlyForecasts()?.count == 0 ? nil : city?.hourlyForecasts()?[0] as? WAHourlyForecast
        let conditionCode = Int(hourlyForcast?.conditionCode ?? city?.conditionCode ?? 0)
        return WeatherImageLoader.conditionImage(withConditionIndex: conditionCode)
    }

    func glyph(size: CGSize) -> UIImage? {
        let hourlyForcast = city?.hourlyForecasts()?.count == 0 ? nil : city?.hourlyForecasts()?[0] as? WAHourlyForecast
        let conditionCode = Int(hourlyForcast?.conditionCode ?? city?.conditionCode ?? 0)

        let imageName = WeatherImageLoader.conditionImageName(withConditionIndex: conditionCode)
        return WeatherImageLoader.conditionImageNamed(imageName, size: size, cloudAligned: false, stroke: false, strokeAlpha: 0.0, lighterColors: false)
    }

    func cityDidFinishWeatherUpdate(_ city: City!) {
        MCLogger.log("City finished update: \(city.name ?? "Unknown")")
        postNotification()
    }

    func cityDidStartWeatherUpdate(_ city: City!) {
        MCLogger.log("City starting weather update: \(city.name ?? "Unknown")")
    }

    func todayModel(_: WATodayModel!, forecastWasUpdated forecast: WAForecastModel!) {
        forecastModel = forecast
        city = forecastModel?.city
        MCLogger.log("Forecast updated: \(forecastModel?.city?.name ?? "Unknown")")
        postNotification()
    }

    func todayModelWantsUpdate(_ model: WATodayModel!) {
        MCLogger.log("Today model wants update")
        model.executeUpdate(completion: nil)
    }

    func createGreetingView() -> WAGreetingView {
        let greetingView = WAGreetingView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        greetingView?.todayModel = todayModel
        greetingView?.createViews()
        greetingView?.update()
        return greetingView!
    }
}
