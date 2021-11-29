import Asteroid14C
import Cephei
import Orion

class SpringboardHook: ClassHook<SpringBoard> {
    @Property(.nonatomic) var weatherModel = WeatherModel.shared
    func applicationDidFinishLaunching(_ application: UIApplication) {
        orig.applicationDidFinishLaunching(application)
        let deadlineTime = DispatchTime.now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.weatherModel.backgroundThread.async {
                WeatherModel.shared.updateCityWeather()
                WeatherModel.shared.updateModel()
            }
        }
    }
}
