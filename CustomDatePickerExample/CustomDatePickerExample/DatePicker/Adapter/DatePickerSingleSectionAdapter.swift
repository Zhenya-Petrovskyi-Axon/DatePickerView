//
//  SingleSectionAdapter.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 26.04.2022.
//

import Combine
import CombineCocoa
import UIKit

final class DatePickerSingleSectionAdapter<Item: Hashable> {
    
    private enum Section: CaseIterable {
        case main
    }
    
    // MARK: - Public properties
    var defaultRowAnimation: UITableView.RowAnimation = .none {
        didSet {
            self.dataSource?.defaultRowAnimation = defaultRowAnimation
        }
    }

    // MARK: - Private properties
    private let tableView: UITableView
    
    private let cellIdentifier: (Item) -> String
    private let render: (Item, UITableViewCell) -> Void
    private var items: [Item] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item>? = { [weak self] in
        guard let self = self else { return nil }

        let dataSource = UITableViewDiffableDataSource<Section, Item>(
            tableView: self.tableView) { tableView, indexPath, item -> UITableViewCell? in
                let cellId = self.cellIdentifier(item)
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: cellId,
                    for: indexPath
                )
                
                self.render(item, cell)
                return cell
            }
        
        dataSource.defaultRowAnimation = self.defaultRowAnimation
        // ---
        // Set initial dataSource state to empty
        // This need to fix strange crash with incorrect section count insertion/deletion
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let sections = Section.allCases
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems([], toSection: $0) }
        dataSource.apply(snapshot, animatingDifferences: false)
        // ---
        return dataSource

    }()
    
    // MARK: - Initializations and Deallocations
    init(tableView: UITableView,
         defaultRowAnimation: UITableView.RowAnimation = .none,
         registerCells: (UITableView) -> Void,
         cellIdentifier: @escaping (Item) -> String,
         render: @escaping (Item, UITableViewCell) -> Void) {
        self.defaultRowAnimation = defaultRowAnimation
        self.tableView = tableView
        registerCells(tableView)
        self.cellIdentifier = cellIdentifier
        self.render = render
    }
    
    // MARK: - Public methods
    func update(items: [Item], animated: Bool = false) {
        guard items != self.items else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        let reload = {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
        if animated {
            reload()
        } else {
            // Allow diffs without animation.
            UIView.animate(withDuration: 0) {
                reload()
            }
        }
        self.items = items
    }
}
