import Asteroid14C
import Orion

struct LockscreenWeatherIcon: HookGroup {}

class SBFLockScreenDateViewHook: ClassHook<SBFLockScreenDateView> {
    typealias Group = LockscreenWeatherIcon
    @Property(.nonatomic) var weatherModel = WeatherModel.shared
    @Property(.nonatomic) var weatherImage: UIImageView? = nil
    @Property(.nonatomic) var baseRestingFrame: CGRect? = nil

    func layoutSubviews() {
        orig.layoutSubviews()

        if weatherImage == nil, target.frame != CGRect.zero {
            NotificationCenter.default.addObserver(target, selector: #selector(weatherUpdated(notification:)), name: Notification.Name(ASTEROID_WEATHER_UPDATE), object: nil)

            setupWeatherImage()

            delayWithSeconds(2, completion: { self.updateWeatherIcon() })
        }

        target.restingFrame = restingFrame()
    }

    func setDateToTimeStretch(_ stretch: Double) {
        orig.setDateToTimeStretch(stretch)
        let baseline = target.subtitleBaselineOffsetFromOrigin() + target.subtitleBaselineOffsetFromOrigin() / 4
        weatherImage?.center = CGPoint(x: target.frame.size.width / 2.0, y: baseline + stretch)
    }

    func setSubtitleHidden(_ hidden: Bool) {
        orig.setSubtitleHidden(hidden)
        if weatherImage != nil {
            UIView.transition(with: weatherImage!, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                  self.weatherImage!.isHidden = hidden
                              })
        }
    }

    func restingFrame() -> CGRect {
        let frame = orig.restingFrame()
        let newFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height + (weatherImage?.frame.height ?? 0.0) + 10) // Magic number = nice padding
        return newFrame
    }

    func _setSubtitleAlpha(_ alpha: Double) {
        orig._setSubtitleAlpha(alpha)
        weatherImage?.alpha = alpha
    }

    // orion:new
    func weatherUpdated(notification _: Notification) {
        updateWeatherIcon()

        target.restingFrame = restingFrame()
    }

    // orion:new
    func updateWeatherIcon() {
        if let icon = weatherModel.glyph() {
            UIView.transition(with: weatherImage!,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: {
                                  self.weatherImage!.image = icon // .withRenderingMode(.alwaysTemplate)
                                  // self.weatherImage!.tintColor = self.target.textColor()
                              },
                              completion: nil)
        }
        MCLogger.log("Updating Weather Icon: Lockscreen")
        // target.restingFrame = target.restingFrame()
    }

    // orion:new
    func setupWeatherImage() {
        weatherImage = UIImageView()
        if let icon = weatherModel.glyph() {
            weatherImage!.image = icon // .withRenderingMode(.alwaysTemplate)
        }
        // weatherImage?.text = "HELLO WORLD"
        weatherImage?.sizeToFit()
        weatherImage?.center = CGPoint(x: target.frame.size.width / 2.0, y: target.subtitleBaselineOffsetFromOrigin() + target.subtitleBaselineOffsetFromOrigin() / 4)
        target.addSubview(weatherImage!)

        // addImageHeight()
    }
}

class NCNotificationStructuredListViewControllerHook: ClassHook<NCNotificationStructuredListViewController> {
    // setMasterListView:(NCNotificationListView *)arg1
    func setMasterListView(_ view: NCNotificationListView) {
        let shiftedCenter = CGPoint(x: view.center.x, y: view.center.y + 15)
        view.center = shiftedCenter
        orig.setMasterListView(view)
    }
}
