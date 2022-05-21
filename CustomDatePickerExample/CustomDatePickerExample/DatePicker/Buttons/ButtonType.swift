//
//  ButtonType.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 13.02.2022.
//

import UIKit

enum CustomButtonType {
    case pickerSave
    case pickerCancel
}

extension CustomButtonType {
    var title: String {
        switch self {
        case .pickerSave:
            return "Save"
        case .pickerCancel:
            return "Cancel"
        }
    }
    
    var font: UIFont {
        switch self {
        case .pickerSave:
            return .systemFont(ofSize: 16)
        case .pickerCancel:
            return .systemFont(ofSize: 16)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .pickerCancel:
            return .red
        default:
            return .black
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .pickerCancel:
            return .white
        default:
            return .yellow
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .pickerSave, .pickerCancel:
            return 0
        }
    }
    
    var borderColor: CGColor {
        switch self {
        case .pickerSave:
            return UIColor.black.cgColor
        default:
            return UIColor.lightGray.cgColor
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .pickerSave:
            return 6
        default:
            return 0
        }
    }
    
    var image: UIImage? {
        switch self {
        default:
            return nil
        }
    }
}
