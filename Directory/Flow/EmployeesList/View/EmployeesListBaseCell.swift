import Foundation
import UIKit
import Kingfisher

class EmployeesListBaseCell: UITableViewCell {
    private lazy var containerView = UIView()
    private lazy var rootView = UIStackView()
    private lazy var leftView = UIStackView()
    private lazy var rightView = UIImageView()

    private struct Constants {
        static let spacing = 16.0
        static let dimension = 100.0
        static let height = dimension + 2 * spacing
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        selectionStyle = .none
        backgroundColor = .clear
        setupRootView()
        setupLeftView()
        setupRightView()
    }

    func setColor(_ color: UIColor) {
        containerView.backgroundColor = color
    }

    func setIcon(_ url: URL? = nil, urlLowRes: URL? = nil, defaultIcon: UIImage) {
        if let url = url {
            let option: KingfisherOptionsInfo = urlLowRes == nil ? [] : [.lowDataMode(.network(urlLowRes!))]
            rightView.kf.setImage(with: url, placeholder: defaultIcon, options: option)
        } else {
            rightView.image = defaultIcon
        }
    }

    func addToLeftView(_ view: UIView) {
        leftView.addArrangedSubview(view)
    }

    private func setupRootView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.roundCorner(Constants.spacing)
        containerView.dropShadow(Constants.spacing / 4)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: Constants.height),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.spacing),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.spacing),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing)
        ])

        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.spacing = Constants.spacing
        containerView.addSubview(rootView)

        NSLayoutConstraint.activate([
            rootView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.spacing),
            rootView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.spacing),
            rootView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.spacing),
            rootView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.spacing)
        ])
    }

    private func setupLeftView() {
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.axis = .vertical
        leftView.distribution = .equalSpacing
        leftView.heightAnchor.constraint(equalToConstant: Constants.dimension).isActive = true

        rootView.addArrangedSubview(leftView)
    }

    private func setupRightView() {
        rightView.translatesAutoresizingMaskIntoConstraints = false
        rightView.contentMode = .scaleAspectFill
        rightView.roundCorner(Constants.dimension / 2)
        rightView.kf.indicatorType = .activity

        rightView.heightAnchor.constraint(equalToConstant: Constants.dimension).isActive = true
        rightView.widthAnchor.constraint(equalToConstant: Constants.dimension).isActive = true

        rootView.addArrangedSubview(rightView)
    }
}
