//
//  DatePickerScrollBehaviorConfigurator.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 03.05.2022.
//

import UIKit

final class DatePickerScrollBehaviorConfigurator: ScrollBehaviorConfigurator {
    typealias CellType = DatePickerCell
    
    private let cellHeight: CGFloat
    
    init(cellHeight: CGFloat) {
        self.cellHeight = cellHeight
    }
    
    /// Method to configure scroll behavior
    /// - Parameters:
    ///   - table: UITable view
    ///   - velocity: CGPoint from table view delegate / publisher
    ///   - target: UnsafeMutablePointer<CGPoint>
    func performScroll(_ table: UITableView, _ velocity: CGPoint, _ target: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            var offset: CGFloat = 0
            if let indexPath = setupIndexPath(table, target) {
                offset = table.rectForRow(at: indexPath).origin.y
            }
            let off = ((offset / cellHeight).rounded(.toNearestOrAwayFromZero)) * cellHeight
            let newOffset = CGPoint(x: 0, y: off)
            target.pointee = newOffset
            
        } else if velocity.y < 0 {
            var offset: CGFloat = cellHeight * 4
            
            if let indexPath = setupIndexPath(table, target) {
                offset = table.rectForRow(at: indexPath).origin.y - (cellHeight * 2)
            }
            
            let rect = CGRect(origin: table.contentOffset, size: table.bounds.size)
            let visiblePoint = CGPoint(x: rect.midX, y: rect.midY)
            
            guard let indexPath = table.indexPathForRow(at: visiblePoint),
                  indexPath.row != 0
            else {
                return
            }
            
            let off = ((offset / cellHeight).rounded(.toNearestOrAwayFromZero)) * cellHeight
            let newOffset = CGPoint(x: 0, y: off)
            target.pointee = newOffset
            
        } else if velocity.y == 0 {
            let rect = CGRect(origin: table.contentOffset, size: table.bounds.size)
            let visiblePoint = CGPoint(x: rect.midX, y: rect.midY)
            
            guard var indexPath = table.indexPathForRow(at: visiblePoint),
                  let cell = table.cellForRow(at: indexPath) as? CellType
            else {
                return
            }
            
            let position = table.contentOffset.y - cell.frame.origin.y
            
            if position > cell.frame.size.height / 2 {
                indexPath.row += 1
                return
            }
            
            table.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    /// Method to detect top cell index path or to return index path with inset of cell height
    /// - Parameters:
    ///   - table: Any table view
    ///   - target: UnsafeMutablePointer<CGPoint>
    /// - Returns: Index path or nil
    private func setupIndexPath(_ table: UITableView, _ target: UnsafeMutablePointer<CGPoint>) -> IndexPath? {
        if let indexPath = table.indexPathForRow(at: target.pointee) {
            return indexPath
        } else if let indexPath = table.indexPathForRow(at: CGPoint(x: 0, y: target.pointee.y + cellHeight)) {
            return indexPath
        } else if let indexPath = table.indexPathForRow(at: CGPoint(x: 0, y: target.pointee.y + (cellHeight * 2))) {
            return indexPath
        }
        return nil
    }
}
