import Asteroid14C
import Orion
let ENABLE_LOCKSCREEN_TEXT = "EnableLockScreenText"

struct LockScreenText: HookGroup {}

class SBUICallToActionLabelHook: ClassHook<SBUICallToActionLabel> {
    typealias Group = LockScreenText

    @Property(.nonatomic) var weatherModel = WeatherModel.shared

    func setText(_: String, forLanguage language: String, animated: Bool) {
        orig.setText(weatherModel.currentConditionOverview(), forLanguage: language, animated: animated)
    }
}
