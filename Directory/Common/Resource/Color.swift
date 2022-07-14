import Foundation
import UIKit

struct Color {
    static let regularBackground = UIColor(hex: 0xADD4DE)
    static let regularCard = UIColor(hex: 0xFDEFD8)
    static let infoBackground = UIColor(hex: 0xFDAAAA)
    static let infoCard = UIColor(hex: 0xFEDDC1)
    static let errorCard = UIColor(hex: 0xFEF390)
}

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
