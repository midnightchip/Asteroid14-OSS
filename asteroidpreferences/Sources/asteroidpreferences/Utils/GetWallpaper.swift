import Foundation
import UIKit
#if PREFS
    import asteroidpreferencesC
#elseif TWEAK
    import Asteroid14C
#endif

func getWallpaper(enableHome: Bool) -> UIImage? {
    var imageData: NSData
    let fileMngr = FileManager.default
    if UITraitCollection.current.userInterfaceStyle == .dark {
        if existsAtPath("/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap"), enableHome {
            if existsAtPath("/var/mobile/Library/SpringBoard/HomeBackgrounddark.cpbitmap") {
                imageData = NSData(contentsOfFile: "/var/mobile/Library/SpringBoard/HomeBackgrounddark.cpbitmap")!
            } else {
                imageData = NSData(contentsOfFile: "/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap")!
            }
        } else {
            if existsAtPath("/var/mobile/Library/SpringBoard/LockBackgrounddark.cpbitmap") {
                imageData = NSData(contentsOfFile: "/var/mobile/Library/SpringBoard/LockBackgrounddark.cpbitmap")!
            } else {
                imageData = NSData(contentsOfFile: "/var/mobile/Library/SpringBoard/LockBackground.cpbitmap") ?? NSData()
            }
        }
    } else {
        if fileMngr.fileExists(atPath: "/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap"), enableHome {
            imageData = NSData(contentsOfFile: "/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap") ?? NSData()
        } else {
            imageData = NSData(contentsOfFile: "/var/mobile/Library/SpringBoard/LockBackground.cpbitmap") ?? NSData()
        }
    }
    let imageArray: [AnyObject]? = CPBitmapCreateImagesFromData(imageData, nil, 1, nil).takeRetainedValue() as [AnyObject]
    
    var img: UIImage 
    if imageArray?.count ?? 0 > 0 {
        img = UIImage(cgImage: imageArray?[0] as! CGImage)
    } else {
        img = UIImage()
    }
    return img
}

private func existsAtPath(_ path: String) -> Bool {
    return FileManager.default.fileExists(atPath: path)
}
