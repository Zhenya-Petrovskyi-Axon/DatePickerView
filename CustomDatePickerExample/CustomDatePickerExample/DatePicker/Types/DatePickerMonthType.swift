//
//  DatePickerMonthType.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 28.04.2022.
//

import Foundation

// TODO: - Revisit configuration with Localizables
enum DOBPickerMonthType: Int, CaseIterable {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    
    var title: String {
        switch self {
        case .january:
            return "Jan"
        case .february:
            return "Feb"
        case .march:
            return "Mar"
        case .april:
            return "Apr"
        case .may:
            return "May"
        case .june:
            return "Jun"
        case .july:
            return "Jul"
        case .august:
            return "Aug"
        case .september:
            return "Sep"
        case .october:
            return "Oct"
        case .november:
            return "Nov"
        case .december:
            return "Dec"
        }
    }
}
