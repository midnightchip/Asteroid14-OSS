import AudioToolbox
import Cephei
import Foundation
import UIKit

func bridge<T: AnyObject>(obj: T) -> UnsafeRawPointer {
    return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

func bridge<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

func bridgeRetained<T: AnyObject>(obj: T) -> UnsafeRawPointer {
    return UnsafeRawPointer(Unmanaged.passRetained(obj).toOpaque())
}

func bridgeTransfer<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
}

func formatTime(offset: Int64) -> UInt64 {
    if offset.signum() == -1 {
        return 0
    }
    let digits = String(offset)
    if digits.count <= 2 {
        return 3600 // 1 Hour
    } else if digits.count == 3 {
        let firstDigit = UInt64(digits.prefix(1)) ?? 0
        let restOfDigits = UInt64(digits[digits.index(after: digits.startIndex)...]) ?? 0
        if firstDigit < 1 {
            return 3600 + restOfDigits * 60
        } else {
            return firstDigit * 3600 + restOfDigits * 60
        }
    } else {
        let first2Digits = UInt64(digits.prefix(2)) ?? 0
        let restOfDigits = UInt64(digits[digits.index(digits.startIndex, offsetBy: 1)...]) ?? 0
        if first2Digits < 1 {
            return 3600 + restOfDigits * 60
        } else {
            return first2Digits * 3600 + restOfDigits * 60
        }
    }
}

func startRespring() {
    let blurEffect = UIBlurEffect(style: .dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = UIScreen.main.bounds
    blurEffectView.alpha = 0.0

    UIApplication.shared.keyWindow?.addSubview(blurEffectView)

    UIView.animate(withDuration: 1.5, animations: {
        blurEffectView.alpha = 1.0
    }) { finished in
        if finished {
            MCLogger.log("Respringing...")
            MCLogger.log("Squiddy says hello")
            MCLogger.log("Midnight replies, 'Always remember who you are.'")
            graduallyAdjustBrightnessToValue(endValue: 0.0)
        }
    }
}

func graduallyAdjustBrightnessToValue(endValue: CGFloat) {
    let startValue = UIScreen.main.brightness

    var fadeInterval = 0.01
    let delayInSeconds = 0.005
    if endValue < startValue {
        fadeInterval = -fadeInterval
        var brightness = startValue
        while abs(brightness - endValue) > 0 {
            brightness += fadeInterval

            if abs(brightness - endValue) < abs(fadeInterval) {
                brightness = endValue
            }

            let dispatchTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                UIScreen.main.brightness = brightness
            }
        }

        let finalDarkScreen = UIView(frame: UIScreen.main.bounds)
        finalDarkScreen.backgroundColor = UIColor.black
        finalDarkScreen.alpha = 0.3

        // add it to the main window, but with no alpha
        UIApplication.shared.keyWindow?.addSubview(finalDarkScreen)

        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            finalDarkScreen.alpha = 1.0
        }, completion: { finished in
            if finished {
                // DIE
                AudioServicesPlaySystemSound(1521)
                sleep(1)
                HBRespringController.respring()
            }
        })
    }
}
