import Orion
import Asteroid14C


@objcMembers @objc(LiveWeatherIconView) class LiveWeatherIconView: UIView {
    var referenceView: WUIWeatherConditionBackgroundView?
    var weatherModel = WeatherModel.shared
    var setup = false
    var tempLabel: UILabel?
    var gradientView: UIView?
    var logo: UIImageView?
    var gradientLayer: CAGradientLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        clipsToBounds = true
        delayWithSeconds(2, completion: { self.updateWeatherDisplay() })
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    func updateWeatherDisplay() {
        if !setup {
            // TODO: Pref this
            setupReferenceView()
            setupTempLabel()
            setupLogoView()
            NotificationCenter.default.addObserver(self, selector: #selector(weatherUpdated(notification:)), name: Notification.Name(ASTEROID_WEATHER_UPDATE), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(pauseAnimation(notification:)), name: Notification.Name(PAUSE_ANIMATION), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(resumeAnimation(notification:)), name: Notification.Name(RESUME_ANIMATION), object: nil)
            setup = true
        }

        if tempLabel?.bounds == CGRect(x: 0, y: 0, width: 0, height: 0) {
            setupTempLabel()
        }

        if logo?.bounds == CGRect(x: 0, y: 0, width: 0, height: 0) {
            setupLogoView()
        }

        // Update temperature text
        // TODO: Animate these transitions
        UIView.transition(with: tempLabel!,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { self.tempLabel!.text = self.weatherModel.localeTemperature() },
                          completion: nil)

        tempLabel!.layoutSubviews()

        // Icon Image

        if let icon = weatherModel.glyph() {
            UIView.transition(with: logo!,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: { self.logo!.image = icon },
                              completion: nil)
        }
        logo!.layoutSubviews()
        layoutSubviews()

        /* gradientLayer.hidden = false;
         gradientLayer = gradientFromWeatherGradient(referenceView.background.gradientLayer)
         gradientLayer.frame = self.gradientView.frame
         gradientView.layer.sublayers = nil
         gradientView.layer.insertSublayer(gradientLayer, at:0) */
    }

    func updateSize(_ size: CGSize) {
        if frame.size != size {
            frame.size = size
            updateWeatherDisplay()
        }
    }

    func weatherUpdated(notification _: Notification) {
        MCLogger.log("Weather App Recieved Update")
        updateWeatherDisplay()
    }

    func pauseAnimation(notification _: Notification) {
        referenceView?.background()?.condition()?.pause()
        MCLogger.log("Weather App Pausing")
    }

    func resumeAnimation(notification _: Notification) {
        referenceView?.background()?.condition()?.resume()
        MCLogger.log("Weather App Resuming")
    }

    func setupTempLabel() {
        tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        tempLabel?.font = UIFont.systemFont(ofSize: 15.00, weight: .semibold)

        tempLabel?.textColor = UIColor.white
        tempLabel?.textAlignment = NSTextAlignment.center
        tempLabel?.center = CGPoint(x: frame.size.width / 1.9, y: frame.size.height / 1.3)
        addSubview(tempLabel!)
    }

    func setupLogoView() {
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
        referenceView = WUIWeatherConditionBackgroundView(frame: frame)
        // TODO: Prefs
        // Hide the background gradient
        // referenceView?.background()?.gradientLayer.isHidden = true
        referenceView?.background()?.setCity(weatherModel.city)
        referenceView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        referenceView?.clipsToBounds = true
        if referenceView != nil {
            addSubview(referenceView!)
            sendSubviewToBack(referenceView!)
            referenceView!.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
            referenceView!.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
            referenceView!.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
            referenceView!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true
        }

        // Gradient

        gradientView = UIView(frame: frame)
        gradientView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gradientView?.clipsToBounds = true

        if gradientView != nil {
            addSubview(gradientView!)
            sendSubviewToBack(gradientView!)
            gradientView!.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
            gradientView!.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
            gradientView!.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
            gradientView!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true
        }
    }

    func gradient(weatherGradient: WUIGradientLayer) -> CAGradientLayer {
        let localGradient = CAGradientLayer()
        localGradient.colors = weatherGradient.colors
        localGradient.locations = weatherGradient.locations
        localGradient.type = weatherGradient.type
        localGradient.startPoint = weatherGradient.startPoint
        localGradient.endPoint = weatherGradient.endPoint
        return localGradient
    }
}
