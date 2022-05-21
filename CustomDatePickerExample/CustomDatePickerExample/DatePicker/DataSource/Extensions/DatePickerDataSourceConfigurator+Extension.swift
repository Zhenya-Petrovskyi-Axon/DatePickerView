//
//  DatePickerDataSourceConfigurator+Extension.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 28.04.2022.
//

import UIKit

// MARK: - Extension for helper methods to configure cells
extension DatePickerDataSourceConfigurator {
    func registerCellsForYear(_ tableView: UITableView) {
        tableView.register(CellType.self, forCellReuseIdentifier: CellType.reuseIdentifier)
    }
    
    func registerCellsForMonth(_ tableView: UITableView) {
        tableView.register(CellType.self, forCellReuseIdentifier: CellType.reuseIdentifier)
    }
    
    func registerCellsForDays(_ tableView: UITableView) {
        tableView.register(CellType.self, forCellReuseIdentifier: CellType.reuseIdentifier)
    }
    
    func getCellIdentifierForYear() -> String { CellType.reuseIdentifier }
    
    func getCellIdentifierForMonth() -> String { CellType.reuseIdentifier }
    
    func getCellIdentifierForDays() -> String { CellType.reuseIdentifier }
    
    func renderYearCell(_ item: Int, _ cell: UITableViewCell) {
        switch (item, cell) {
        case (let item, let cell as CellType):
            cell.render(with: "\(item)")
        default:
            break
        }
    }
    
    func renderMonthCell(_ item: Int, _ cell: UITableViewCell) {
        switch (item, cell) {
        case (let item, let cell as CellType):
            let month = DOBPickerMonthType.allCases[item - 1].title
            cell.render(with: month)
            cell.label.textAlignment = .left
        default:
            break
        }
    }
    
    func renderDaysCell(_ item: Int, _ cell: UITableViewCell) {
        switch (item, cell) {
        case (let item, let cell as CellType):
            cell.render(with: "\(item)")
        default:
            break
        }
    }
}
