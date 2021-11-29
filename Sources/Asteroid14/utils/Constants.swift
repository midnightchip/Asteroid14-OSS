import Asteroid14C
import Orion

let COMPLETED_SETUP = "completedAsteroidSetup"

let NOTIFICATION_KEY = "me.midnightchips.asteroidkey"

let ASTEROID_STATE_CHANGED = "com.midnightchips.asteroid-appstate-changed"

let ASTEROID_WEATHER_UPDATE = "com.midnightchips.asteroid-weather-update"

let RESUME_ANIMATION = "ResumeAnimation"

let PAUSE_ANIMATION = "PauseAnimation"

let SERVER_NAME = "me.midnightchips.asteroid14"

// Mark: - Home Screen
let ENABLE_HOME_SCREEN_ANIMATION = "EnableHomeScreenAnimation"
let HOME_SCREEN_LOCATION_INDEX = "HomeScreenLocationIndex"
let ENABLE_CUSTOM_HOME_LOCATION = "EnableCustomLocationHome"
let ENABLE_ANIMATION_BACKGROUND_HOME = "EnableAnimationBackgroundHome"
let ENABLE_HOME_CUSTOM_CONDITION = "EnableCustomHomeCondition"
let HOME_SCREEN_CONDITION_INDEX = "HomeScreenCustomConditionIndex"
let HOME_NIGHT_ENABLED = "HomeCustomLocationNight"

// Mark: - Lockscreen
let ENABLE_LOCKSCREEN_ANIMATION = "EnableLockScreenAnimation"
let ENABLE_LOCKSCREEN_ANIMATION_BACKGROUND = "EnableAnimationBackgroundLockScreen"
let ENABLE_CUSTOM_LOCATION_LOCKSCREEN = "EnableCustomLocationLockScreen"
let ENABLE_CUSTOM_CONDITION_LOCKSCREEN = "EnableCustomLockScreenCondition"
let ENABLE_NIGHT_CONDITION_LOCKSCREEN = "LockCustomLocationNight"
let LOCK_SCREEN_LOCATION_INDEX = "LockScreenLocationIndex"
let LOCK_SCREEN_CONDITION_INDEX = "LockScreenCustomConditionIndex"
let ENABLE_LOCKSCREEN_WEATHER_ICON = "EnableLockScreenIcon"

// Mark: - Apps
let APP_ENABLE_HOOK = "AppEnableHooks"
let APP_LOCATION_INDEX = "AppLocationIndex"
let APP_CUSTOM_CONDITION_INDEX = "AppCustomConditionIndex"
let APP_ENABLE_ANIMATION = "AppEnableAnimation"
let APP_ENABLE_LOCATION_NIGHT = "AppEnableLocationNight"
let APP_ENABLE_CUSTOM_CONDITION = "AppEnableCustomCondition"
let APP_ENABLE_CUSTOM_LOCATION = "AppEnableCustomLocation"
let APP_ENABLE_ANIMATION_BACKGROUND = "AppEnableAnimationBackground"
let APP_ENABLE_WEATHER_GLYPH = "AppEnableWeatherGlyph"
let APP_ENABLE_TEMPERATURE = "AppEnableTemperature"
let APP_SELECTED_IDS = "SelectedLiveWeatherApps"

let STATUS_CARRIER_CONTENT = "StatusBarCarrierContent"
let STATUS_TAP_TIME = "StatusTapTime"
let STATUS_INLINE_CONTENT = "StatusInlineContent"
let DATE_CHECK = "DATE_CHECK"

let TWEAK_ENABLED = "asteroidEnabled"

@objc enum StatusContentType: Int {
    case original
    case image  
    case temperature
    case both
}

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}
