//
//  AppButton.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 13.02.2022.
//

import Combine
import CombineCocoa
import Foundation
import UIKit

class AppButton: UIButton {
    private var selectedStateColor: UIColor { unSelectedStateColor?.withAlphaComponent(0.8) ?? .black }
    private var unSelectedStateColor: UIColor?
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? selectedStateColor : unSelectedStateColor
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? unSelectedStateColor : .lightGray
        }
    }
    
    func configure(buttonType: CustomButtonType) {
        setTitle(buttonType.title, for: .normal)
        setTitleColor(buttonType.textColor, for: .normal)
        titleLabel?.font = buttonType.font
        if buttonType.cornerRadius > 0 {
            layer.cornerRadius = buttonType.cornerRadius
        } else {
            layer.cornerRadius = self.layer.bounds.height / 2
        }
        
        if let image = buttonType.image {
            setImage(image, for: .normal)
            imageEdgeInsets.right = 4
        }
        
        // To make an inner boarder
        frame = frame.insetBy(dx: -buttonType.borderWidth, dy: -buttonType.borderWidth)
        layer.borderWidth = buttonType.borderWidth
        layer.borderColor = buttonType.borderColor
        backgroundColor = buttonType.backgroundColor
        unSelectedStateColor = buttonType.backgroundColor
    }
}
