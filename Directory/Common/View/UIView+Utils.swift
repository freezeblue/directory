import Foundation
import UIKit

extension UIView {
    func dropShadow(_ size: CGFloat) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: size)
        layer.shadowRadius = size
    }

    func roundCorner(_ size: CGFloat) {
        layer.cornerRadius = size
        clipsToBounds = true
    }
}
