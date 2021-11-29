import Asteroid14C
import Cephei
import Orion

foo

struct KickStart: Tweak {
    private let preferences = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    static func handleError(_ error: OrionHookError) {
        MCLogger.log("ORION ERROR: \(error.description), \(String(describing: error.failureReason)), \(String(describing: error.recoverySuggestion))")
    }

    init() {
        MCLogger.info("Asteroid initializing")
        preferences.register(defaults: [
            ENABLE_HOME_SCREEN_ANIMATION: false,
            ENABLE_LOCKSCREEN_ANIMATION: false,
            ENABLE_LOCKSCREEN_TEXT: false,
            ENABLE_LOCKSCREEN_WEATHER_ICON: false,
            COMPLETED_SETUP: false,
            "HideAnimationBackground": true,
        ])

        if preferences.bool(forKey: COMPLETED_SETUP), preferences.bool(forKey: WEATHER_AVAILABLE), preferences.bool(forKey: TWEAK_ENABLED) {
            StatusBarGroup().activate()
            if preferences.bool(forKey: ENABLE_HOME_SCREEN_ANIMATION) {
                HomeScreenAnimation().activate()
            }
            if preferences.bool(forKey: ENABLE_LOCKSCREEN_ANIMATION) {
                LockScreenAnimation().activate()
            }
            if preferences.bool(forKey: ENABLE_LOCKSCREEN_TEXT) {
                LockScreenText().activate()
            }
            if preferences.bool(forKey: ENABLE_LOCKSCREEN_WEATHER_ICON) {
                LockscreenWeatherIcon().activate()
            }
            if preferences.bool(forKey: APP_ENABLE_HOOK) {
                WeatherApp().activate()
            }
        } else if !preferences.bool(forKey: COMPLETED_SETUP) {
            OnBoardSetup().activate()
        }

        // Used to kickstart AWeatherModel.
        // Get crashes loaded
        dlopen("/Library/MobileSubstrate/DynamicLibraries/Cr4shedSB.dylib", RTLD_NOW)
        /* Weather */
        dlopen("System/Library/PrivateFrameworks/Weather.framework/Weather", RTLD_NOW)
        /* WeatherUI */
        dlopen("System/Library/PrivateFrameworks/WeatherUI.framework/WeatherUI", RTLD_NOW)

        /* Sleep */
        dlopen("/System/Library/PrivateFrameworks/SleepDaemon.framework/SleepDaemon", RTLD_NOW)

        //WeatherModel.shared.kickstart()
    }
}
