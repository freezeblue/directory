import Foundation
import UIKit

protocol BaseTableViewCell {    
    static var id: String { get }
    func configureWith<VIEWMODEL: BaseTableViewCellViewModel>(viewModel: VIEWMODEL) -> UITableViewCell
}
