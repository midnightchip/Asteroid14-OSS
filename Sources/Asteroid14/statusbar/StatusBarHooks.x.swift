import Asteroid14C
import Cephei
import Orion

struct StatusBarGroup: HookGroup {}

class StatusBarTimeItemHook: ClassHook<_UIStatusBarTimeItem> {
    typealias Group = StatusBarGroup
    func shortTimeView() -> _UIStatusBarStringView {
        let timeView = orig.shortTimeView()
        StatusBarStringViewHook(target: timeView).isTime = true
        return timeView
    }

    func timeView() -> _UIStatusBarStringView {
        let timeView = orig.timeView()
        StatusBarStringViewHook(target: timeView).isTime = true
        return timeView
    }
}

class StatusBarCarrierHook: ClassHook<_UIStatusBarCellularItem> {
    typealias Group = StatusBarGroup
    func serviceNameView() -> _UIStatusBarStringView {
        let serviceNameView = orig.serviceNameView()
        StatusBarStringViewHook(target: serviceNameView).isCarrier = true
        return serviceNameView
    }
}

class StatusBarStringViewHook: ClassHook<_UIStatusBarStringView> {
    @Property(.nonatomic) var weatherModel = WeatherModel.shared
    @Property(.nonatomic) var prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    @Property(.nonatomic, .retain) var tapGesture: UITapGestureRecognizer? = nil
    @Property(.nonatomic) var isTapped = false
    @Property(.nonatomic) var addedTap = false
    @Property(.nonatomic) var addedObservers = false
    @Property(.nonatomic) var isCarrier = false
    @Property(.nonatomic) var isTime = false
    typealias Group = StatusBarGroup

    func didMoveToWindow() {
        orig.didMoveToWindow()
        if !addedTap, isTime, target.text?.contains(":") ?? false, prefs.bool(forKey: STATUS_TAP_TIME, default: false) {
            addedTap = true
        }
        if !addedObservers && (isTime || isCarrier) {
            NotificationCenter.default.addObserver(target, selector: #selector(weatherUpdated(_:)), name: Notification.Name(ASTEROID_WEATHER_UPDATE), object: nil)
        }

        if isTime, target.text?.contains(":") ?? false, tapGesture == nil, prefs.bool(forKey: STATUS_TAP_TIME, default: false) {
            tapGesture = UITapGestureRecognizer(target: target, action: #selector(swapTime(_:)))
            tapGesture?.numberOfTapsRequired = 1
            tapGesture?.cancelsTouchesInView = false
            target.superview?.superview?.addGestureRecognizer(tapGesture!)
        }
    }

    func setText(_ text: String) {
        if isTapped {
            UIView.transition(with: target, duration: 0.15, options: [UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.beginFromCurrentState], animations: {
                self.genTempAndLogoText()
            }, completion: nil)
        } else if isTime, text.contains(":") {
            configureTimeLabel(text)
        } else if isCarrier {
            configureCarrierLabel(text)
        } else {
            orig.setText(text)
        }
    }

    // orion:new
    func configureTimeLabel(_ text: String) {
        let selectedOption = StatusContentType(rawValue: prefs.integer(forKey: STATUS_INLINE_CONTENT, default: 0))
        if selectedOption == .original {
            orig.setText(text)
        } else {
            let tempString = genAttributedText(type: selectedOption ?? .original)
            let timeString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: target.font])
            if selectedOption == .temperature || selectedOption == .both {
                timeString.append(NSAttributedString(string: ", ", attributes: [NSAttributedString.Key.font: target.font]))
            }
            timeString.append(tempString)
            target.attributedText = timeString
        }
    }

    // orion:new
    func configureCarrierLabel(_ text: String) {
        let selectedOption = StatusContentType(rawValue: prefs.integer(forKey: STATUS_CARRIER_CONTENT, default: 0))
        if selectedOption == .original {
            orig.setText(text)
        } else {
            target.attributedText = genAttributedText(type: selectedOption ?? .original)
        }
    }

    // orion:new
    func weatherUpdated(_: Notification) {
        setText(timeString())
    }
    // orion:new
    func genAttributedText(type: StatusContentType) -> NSMutableAttributedString {
        var tempString = NSMutableAttributedString()

        switch type {
        case .original:
            break
        case .image: do {
                let glyphAttachment = getGlyph()
                tempString = NSMutableAttributedString(attachment: glyphAttachment)
            }
        case .temperature: do {
                tempString = NSMutableAttributedString(string: weatherModel.localeTemperature(), attributes: [NSAttributedString.Key.font: target.font])
            }
        case .both: do {
                let weatherAttach = getGlyph()
                tempString = NSMutableAttributedString(string: weatherModel.localeTemperature(), attributes: [NSAttributedString.Key.font: target.font])
                tempString.append(NSAttributedString(attachment: weatherAttach))
            }
        }

        return tempString
    }

    // orion:new
    func genTempAndLogoText() {
        let weatherAttach = getGlyph()
        let tempString = NSMutableAttributedString(string: weatherModel.localeTemperature(), attributes: [NSAttributedString.Key.font: target.font])
        tempString.append(NSAttributedString(attachment: weatherAttach))
        target.attributedText = tempString
    }

    // orion:new
    func getGlyph() -> NSTextAttachment {
        var glyph = weatherModel.glyph() ?? UIImage()
        let aspect = glyph.size.width / glyph.size.height
        glyph = glyph.scale(to: CGSize(width: target.font.lineHeight * aspect, height: target.font.lineHeight))
        glyph = glyph.withRenderingMode(.alwaysTemplate)
        let weatherAttach = NSTextAttachment()
        weatherAttach.bounds = CGRect(x: 0, y: CGFloat(roundf(Float(target.font.capHeight - glyph.size.height))) / 2.0, width: glyph.size.width, height: glyph.size.height)
        weatherAttach.image = glyph
        return weatherAttach
    }

    // orion:new
    func setTimeWithGlyph(_ time: String) {
        var glyph = weatherModel.glyph() ?? UIImage()
        let aspect = glyph.size.width / glyph.size.height
        glyph = glyph.scale(to: CGSize(width: target.font.lineHeight * aspect, height: target.font.lineHeight))
        glyph = glyph.withRenderingMode(.alwaysTemplate)
        let weatherAttach = NSTextAttachment()
        weatherAttach.bounds = CGRect(x: 0, y: CGFloat(roundf(Float(target.font.capHeight - glyph.size.height))) / 2.0, width: glyph.size.width, height: glyph.size.height)
        weatherAttach.image = glyph

        let tempString = NSMutableAttributedString(string: time, attributes: [NSAttributedString.Key.font: target.font])
        tempString.append(NSAttributedString(attachment: weatherAttach))
        target.attributedText = tempString
    }

    // orion:new
    func swapTime(_ sender: UIGestureRecognizer) {
        let location = sender.location(in: sender.view)
        let newFrame = target.superview?.superview?.convert(target.frame, from: target.superview)
        if CGRect(x: newFrame?.origin.x ?? 0.0, y: newFrame?.origin.y ?? 0, width: newFrame?.size.width ?? 0.0, height: (newFrame?.size.height ?? 0.0) + (newFrame?.origin.y ?? 0.0)).contains(location) {
            MCLogger.log("BOOP, we were clicked")
            if !isTapped {
                isTapped = true
                setText("RUNN:")
                target.perform(#selector(resetTime), with: nil, afterDelay: 10.0)
            } else {
                resetTime()
            }
        }
    }

    // orion:new
    func resetTime() {
        isTapped = false
        setText(timeString())
    }

    // orion:new
    func timeString() -> String {
        let timeString = UIApplication.shared.statusBar().statusBar.currentData.timeEntry.stringValue
        let cleanedTimeString = timeString?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return cleanedTimeString ?? ""
    }
}
