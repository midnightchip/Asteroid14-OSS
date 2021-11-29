import Asteroid14C
import Cephei
import Orion

struct LockScreenAnimation: HookGroup {}

class CSCoverSheetViewControllerHook: ClassHook<CSCoverSheetViewController> {
    typealias Group = LockScreenAnimation

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
        updateAnimationView()
    }

    // orion:new
    func updateAnimationView() {
        // Hide background gradient

        var backgroundCity: City?
        if prefs.bool(forKey: ENABLE_CUSTOM_LOCATION_LOCKSCREEN, default: false) {
            backgroundCity = weatherModel.getCityAtIndex(prefs.integer(forKey: LOCK_SCREEN_LOCATION_INDEX, default: 0))
        } else if prefs.bool(forKey: ENABLE_CUSTOM_CONDITION_LOCKSCREEN, default: false) {
            backgroundCity = weatherModel.city?.cityCopy()
            backgroundCity?.conditionCode = Int64(prefs.integer(forKey: LOCK_SCREEN_CONDITION_INDEX, default: 0))
            let isNight = prefs.bool(forKey: ENABLE_NIGHT_CONDITION_LOCKSCREEN, default: false)
            if backgroundCity?.isDay ?? false, isNight {
                let timeDifference = Int64(backgroundCity?.sunsetTime ?? 0) - Int64(backgroundCity?.observationTime ?? 0)
                if timeDifference > 0 {
                    backgroundCity?.observationTime = (backgroundCity?.sunsetTime ?? 0) + 30
                    let currentTimeOffset = backgroundCity?.timeZone?.secondsFromGMT() ?? 0
                    backgroundCity?.timeZone = TimeZone(secondsFromGMT: currentTimeOffset + Int(formatTime(offset: timeDifference)))
                }
            } else if !(backgroundCity?.isDay ?? false), !isNight {
                let timeDifference = Int64(backgroundCity?.sunsetTime ?? 0) - Int64(backgroundCity?.observationTime ?? 0)
                if timeDifference > 0 {
                    backgroundCity?.observationTime = (backgroundCity?.sunsetTime ?? 0) + 30
                    let currentTimeOffset = backgroundCity?.timeZone?.secondsFromGMT() ?? 0
                    backgroundCity?.timeZone = TimeZone(secondsFromGMT: currentTimeOffset + Int(formatTime(offset: timeDifference)))
                }
            }
        } else {
            backgroundCity = weatherModel.city
        }

        // let backgroundCity = weatherModel.city
        referenceView?.background()?.setCity(backgroundCity, animate: true)
        referenceView?.background().tag = 420

        if prefs.bool(forKey: ENABLE_NIGHT_CONDITION_LOCKSCREEN, default: false) {
            referenceView?.background()?.condition()?.forcesNight = 1
        }
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
    func updateView(notification _: Notification) {
        updateAnimationView()
    }

    // orion:new
    func pauseAnimation(notification _: Notification) {
        referenceView?.background()?.condition()?.pause()
        MCLogger.log("Pausing Lock Screen")
    }

    // orion:new
    func resumeAnimation(notification _: Notification) {
        referenceView?.background()?.condition()?.resume()
        MCLogger.log("Resuming Lock Screen")
    }
}
