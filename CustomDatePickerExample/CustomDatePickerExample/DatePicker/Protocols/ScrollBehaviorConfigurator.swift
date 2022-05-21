//
//  ScrollBehaviorConfigurator.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 03.05.2022.
//

import UIKit

protocol ScrollBehaviorConfigurator {
    /// Method will configure scrolling behavior with steps or scroll
    ///  - use with willEndDraggingPublisher or delegate
    /// - Parameters:
    ///   - table: Any UITable View
    ///   - velocity: CGPoint >, < or == to 0
    ///   - target: UnsafeMutablePointer<CGPoint> to detect top coordinates
    func performScroll(_ table: UITableView, _ velocity: CGPoint, _ target: UnsafeMutablePointer<CGPoint>)
}
