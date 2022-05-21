//
//  DatePickerCell.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 26.04.2022.
//

import Foundation
import UIKit

final class DatePickerCell: UITableViewCell, Renderable, Reusable {
    typealias EntityType = String
    
    static let height: CGFloat = 36
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        contentView.backgroundColor = .clear
        selectionStyle = .none
        label.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func render(with entity: EntityType) {
        DispatchQueue.main.async {
            self.label.text = entity
        }
    }
    
    private func setupUI() {
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: DatePickerCell.height),
        ])
    }
}
