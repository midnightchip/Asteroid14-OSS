import Asteroid14C
import Cephei
import Orion

struct HomeScreenAnimation: HookGroup {}

class SBHomeScreenViewControllerHook: ClassHook<SBHomeScreenViewController> {
    typealias Group = HomeScreenAnimation

    @Property(.nonatomic) var referenceView: WUIWeatherConditionBackgroundView? = nil
    @Property(.nonatomic) var weatherModel = WeatherModel.shared
    @Property(.nonatomic) var prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")

    func viewDidLoad() {
        orig.viewDidLoad()
        referenceView = WUIWeatherConditionBackgroundView(frame: target.view.frame)
        referenceView?.background()?.gradientLayer.isHidden = !prefs.bool(forKey: ENABLE_LOCKSCREEN_ANIMATION_BACKGROUND, default: false)
        referenceView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        referenceView?.clipsToBounds = true
        referenceView?.translatesAutoresizingMaskIntoConstraints = false
        if referenceView != nil {
            target.view.addSubview(referenceView!)
            target.view.sendSubviewToBack(referenceView!)
        }

        referenceView?.topAnchor.constraint(equalTo: target.view.topAnchor).isActive = true
        referenceView?.bottomAnchor.constraint(equalTo: target.view.bottomAnchor).isActive = true
        referenceView?.leftAnchor.constraint(equalTo: target.view.leftAnchor).isActive = true
        referenceView?.rightAnchor.constraint(equalTo: target.view.rightAnchor).isActive = true
        addObservers()
        updateView()
    }

    // orion:new
    func addObservers() {
        NotificationCenter.default.addObserver(target, selector: #selector(pauseAnimation(notification:)), name: Notification.Name(PAUSE_ANIMATION), object: nil)
        NotificationCenter.default.addObserver(target, selector: #selector(resumeAnimation(notification:)), name: Notification.Name(RESUME_ANIMATION), object: nil)
        NotificationCenter.default.addObserver(target, selector: #selector(updateView(notification:)), name: Notification.Name(ASTEROID_WEATHER_UPDATE), object: nil)
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil, { _, _, _, _, _ in
            NotificationCenter.default.post(name: NSNotification.Name(ASTEROID_STATE_CHANGED), object: nil)
        }, "com.apple.springboard.screenchanged" as CFString, nil, CFNotificationSuspensionBehavior.deliverImmediately)
    }

    // orion:new
    func pauseAnimation(notification _: Notification) {
        referenceView?.background()?.condition()?.pause()
        MCLogger.log("Pausing Home Screen")
    }

    // orion:new
    func resumeAnimation(notification _: Notification) {
        referenceView?.background()?.condition()?.resume()
        MCLogger.log("Resuming Home Screen")
    }

    // orion:new
    func updateView(notification _: Notification) {
        // if !prefs.bool(forKey: ENABLE_HOME_CUSTOM_CONDITION, default: false) {
        updateView()
        // }
    }

    // orion:new
    func updateView() {
        MCLogger.log("We are updating homescreen view")

        referenceView?.background()?.gradientLayer.isHidden = !prefs.bool(forKey: ENABLE_ANIMATION_BACKGROUND_HOME, default: false)

        var backgroundCity: City?

        if prefs.bool(forKey: ENABLE_CUSTOM_HOME_LOCATION, default: false) {
            backgroundCity = weatherModel.getCityAtIndex(prefs.integer(forKey: HOME_SCREEN_LOCATION_INDEX, default: 0))
        } else if prefs.bool(forKey: ENABLE_HOME_CUSTOM_CONDITION, default: false) {
            backgroundCity = weatherModel.city?.cityCopy()
            if backgroundCity == nil || backgroundCity?.name == nil {
                let index = WeatherPreferences.shared().loadActiveCity()
                backgroundCity = WeatherPreferences.shared().loadSavedCities()[Int(index)]
            }
            backgroundCity?.conditionCode = Int64(prefs.integer(forKey: HOME_SCREEN_CONDITION_INDEX, default: 0))
            let isNight = prefs.bool(forKey: HOME_NIGHT_ENABLED, default: false)
            if backgroundCity?.isDay ?? false, isNight {
                let timeDifference = Int64(backgroundCity?.sunsetTime ?? 0) - Int64(backgroundCity?.observationTime ?? 0)
                if timeDifference > 0 {
                    backgroundCity?.observationTime = (backgroundCity?.sunsetTime ?? 0) + 30
                    let currentTimeOffset = backgroundCity?.timeZone?.secondsFromGMT() ?? 0
                    backgroundCity?.timeZone = TimeZone(secondsFromGMT: currentTimeOffset + Int(formatTime(offset: timeDifference)))
                }
            } else if !(backgroundCity?.isDay ?? false), !isNight {
                let timeDifference = Int64(backgroundCity?.sunriseTime ?? 0) + Int64(backgroundCity?.observationTime ?? 0)
                if timeDifference > backgroundCity?.sunsetTime ?? 0 {
                    backgroundCity?.observationTime = (backgroundCity?.sunriseTime ?? 0) + 30
                    let currentTimeOffset = backgroundCity?.timeZone?.secondsFromGMT() ?? 0
                    backgroundCity?.timeZone = TimeZone(secondsFromGMT: currentTimeOffset + Int(formatTime(offset: timeDifference)))
                }
            }
        } else {
            backgroundCity = weatherModel.city
        }

        referenceView?.background()?.setCity(backgroundCity, animate: true)

        /* let newCondition = WUIWeatherCondition()
         newCondition?.condition = 32
         newCondition?.setTime(1800)
         newCondition?.forcesCondition = true
         newCondition?.forcesNight = 1

         referenceView?.background()?.setCondition(newCondition)
         referenceView?.background().tag = 123 */

        if prefs.bool(forKey: HOME_NIGHT_ENABLED, default: false) {
            referenceView?.background()?.condition()?.forcesNight = 1
            referenceView?.background()?.condition()?.timeOffset = 500 // 21600
        }
    }
}
