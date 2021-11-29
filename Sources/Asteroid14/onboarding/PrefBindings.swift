import Cephei
import Combine
import Foundation

foo

@propertyWrapper
struct Prefs<T> {
    let prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return prefs.object(forKey: key) as? T ?? defaultValue
        }
        set {
            prefs.set(newValue, forKey: key)
        }
    }
}

final class AsteroidPrefs: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    // MARK: - Lockscreen

    @Prefs(ENABLE_LOCKSCREEN_ANIMATION, defaultValue: false)
    var enableLockscreenAnimation: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(ENABLE_LOCKSCREEN_ANIMATION_BACKGROUND, defaultValue: false)
    var enableLockscreenAnimationBackground: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(ENABLE_CUSTOM_LOCATION_LOCKSCREEN, defaultValue: false)
    var enableCustomLocationLockscreen: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(ENABLE_CUSTOM_CONDITION_LOCKSCREEN, defaultValue: false)
    var enableCustomConditionLockscreen: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(ENABLE_NIGHT_CONDITION_LOCKSCREEN, defaultValue: false)
    var enableNightConditionLockscreen: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(ENABLE_LOCKSCREEN_WEATHER_ICON, defaultValue: false)
    var enableLockscreenWeatherIcon: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(ENABLE_LOCKSCREEN_TEXT, defaultValue: false)
    var enableLockscreenText: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(LOCK_SCREEN_CONDITION_INDEX, defaultValue: 0)
    var lockScreenConditionIndex: Int {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(LOCK_SCREEN_LOCATION_INDEX, defaultValue: 0)
    var lockScreenLocationIndex: Int {
        willSet {
            objectWillChange.send()
        }
    }

    // MARK: - Homescreen

    @Prefs(ENABLE_HOME_SCREEN_ANIMATION, defaultValue: false)
    var enableHomeScreenAnimation: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(ENABLE_ANIMATION_BACKGROUND_HOME, defaultValue: false)
    var enableHomeScreenAnimationBackground: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(ENABLE_CUSTOM_HOME_LOCATION, defaultValue: false)
    var enableHomeCustomLocation: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(ENABLE_HOME_CUSTOM_CONDITION, defaultValue: false)
    var enableHomeCustomCondition: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(HOME_NIGHT_ENABLED, defaultValue: false)
    var enableNightConditionHomeScreen: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(HOME_SCREEN_CONDITION_INDEX, defaultValue: 0)
    var homeScreenConditionIndex: Int {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(HOME_SCREEN_LOCATION_INDEX, defaultValue: 0)
    var homeScreenLocationIndex: Int {
        willSet {
            objectWillChange.send()
        }
    }

    // MARK: - Apps

    @Prefs(APP_LOCATION_INDEX, defaultValue: 0)
    var appLocationIndex: Int {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(APP_CUSTOM_CONDITION_INDEX, defaultValue: 0)
    var appCustomConditionIndex: Int {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(APP_ENABLE_ANIMATION, defaultValue: false)
    var appEnableAnimation: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(APP_ENABLE_LOCATION_NIGHT, defaultValue: false)
    var appEnableLocationNight: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(APP_ENABLE_CUSTOM_CONDITION, defaultValue: false)
    var appEnableCustomCondition: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(APP_ENABLE_CUSTOM_LOCATION, defaultValue: false)
    var appEnableCustomLocation: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(APP_ENABLE_ANIMATION_BACKGROUND, defaultValue: false)
    var appEnableAnimationBackground: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(APP_ENABLE_WEATHER_GLYPH, defaultValue: false)
    var appEnableWeatherGlyph: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(APP_ENABLE_TEMPERATURE, defaultValue: false)
    var appEnableTemperature: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(APP_SELECTED_IDS, defaultValue: [])
    var appSelectedIds: [String] {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(APP_ENABLE_HOOK, defaultValue: false)
    var appEnableHook: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    // MARK: - Status Bar

    @Prefs(STATUS_CARRIER_CONTENT, defaultValue: 0)
    var statusCarrierContent: Int {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(STATUS_TAP_TIME, defaultValue: false)
    var enableStatusTapTime: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs(STATUS_INLINE_CONTENT, defaultValue: 0)
    var statusInlineContent: Int {
        willSet {
            objectWillChange.send()
        }
    }

    // MARK: - Onboarding

    @Prefs(COMPLETED_SETUP, defaultValue: false)
    var completedSetup: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs("IS_VALID", defaultValue: false)
    var isValid: Bool {
        willSet {
            objectWillChange.send()
        }
    }

    @Prefs("DATE_CHECK", defaultValue: nil)
    var dateCheck: Date? {
        willSet {
            objectWillChange.send()
        }
    }
}
