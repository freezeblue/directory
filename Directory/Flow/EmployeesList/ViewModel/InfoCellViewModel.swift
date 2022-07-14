import Foundation
import UIKit

final class InfoCellViewModel: BaseTableViewCellViewModel {
    let title: String
    let message: String
    let color: UIColor
    let icon: UIImage

    init(title: String, message: String, color: UIColor, icon: UIImage) {
        self.title = title
        self.message = message
        self.color = color
        self.icon = icon
    }
}
