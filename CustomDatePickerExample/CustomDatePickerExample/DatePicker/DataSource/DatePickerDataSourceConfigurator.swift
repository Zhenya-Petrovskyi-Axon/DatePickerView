//
//  DataSourceConfigurator.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 03.05.2022.
//

import Combine
import CombineCocoa
import UIKit

//swiftlint:disable all
final class DatePickerDataSourceConfigurator: PickerDataSourceConfigurator {
    typealias CellType = DatePickerCell
    
    // MARK: - UI Components
    private let dayTableView: UITableView
    private let monthTableView: UITableView
    private let yearTableView: UITableView
    
    // MARK: - Adapters
    
    // Year
    lazy var yearTableAdapter: DatePickerSingleSectionAdapter<Int>? = { [weak self] in
        guard let self = self else { return nil }
        
        return DatePickerSingleSectionAdapter(
            tableView: yearTableView,
            defaultRowAnimation: .fade) { table in
                self.registerCellsForYear(table)
            } cellIdentifier: { _ in
                self.getCellIdentifierForYear()
            } render: { item, cell in
                self.renderYearCell(item, cell)
            }
    }()
    
    // Month
    lazy var monthTableViewAdapter: DatePickerSingleSectionAdapter<Int>? = { [weak self] in
        guard let self = self else { return nil }
        
        return DatePickerSingleSectionAdapter(
            tableView: monthTableView,
            defaultRowAnimation: .fade) { table in
                self.registerCellsForMonth(table)
            } cellIdentifier: { _ in
                self.getCellIdentifierForMonth()
            } render: { item, cell in
                self.renderMonthCell(item, cell)
            }
    }()
    
    // Day
    lazy var dayTableViewAdapter: DatePickerSingleSectionAdapter<Int>? = { [weak self] in
        guard let self = self else { return nil }
        
        return DatePickerSingleSectionAdapter(
            tableView: dayTableView,
            defaultRowAnimation: .fade) { table in
                self.registerCellsForDays(table)
            } cellIdentifier: { _ in
                self.getCellIdentifierForDays()
            } render: { item, cell in
                self.renderDaysCell(item, cell)
            }
    }()
    
    // MARK: - Data sources
    var yearDataSource: [Int] = []
    var monthsDataSource: [Int] = []
    var daysDataSourceContainer: [Int] = []
    
    var daysDataSource: AnyPublisher<[Int], Never> {
        Publishers.CombineLatest($year, $month)
            .compactMap { $0 }
            .map { [unowned self] (year, month) in
                let month = DOBPickerMonthType.allCases[month?.row ?? 0].rawValue
                let year = yearDataSource[year?.row ?? 0]
                return dateConfigurator.getAllDays(month: month, year: year)
            }.eraseToAnyPublisher()
    }
    
    // MARK: - Final configuration
    var finalDateConfiguration: AnyPublisher<(Int?, Int?, Int?), Never> {
        Publishers.CombineLatest3($year, $month, $day)
            .map { (year, month, day) in
                let day = day?.row ?? 1
                let month = self.monthsDataSource[month?.row ?? 1]
                let year = self.yearDataSource[year?.row ?? 1]
                return (day, month, year)
            }.eraseToAnyPublisher()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Internal use published containers
    @Published private var month: IndexPath?
    @Published private var year: IndexPath?
    @Published private var day: IndexPath?
    
    // MARK: - Dates
    var outputDate: Date?
    private let inputDate: Date?
    
    // MARK: - Services
    private let dateConfigurator: DateConfigurator
    private let scrollConfigurator: ScrollBehaviorConfigurator
    private let cellHeight: CGFloat
    
    init(dayTableView: UITableView,
         monthTableView: UITableView,
         yearTableView: UITableView,
         inputDate: Date?,
         cellHeight: CGFloat) {
        self.scrollConfigurator = DatePickerScrollBehaviorConfigurator(cellHeight: cellHeight)
        self.dayTableView = dayTableView
        self.monthTableView = monthTableView
        self.yearTableView = yearTableView
        self.inputDate = inputDate
        self.cellHeight = cellHeight
        self.dateConfigurator = DatePickerDateConfigurator()
    }
    
    /// Method to bind
    /// - scroll's -> dragging publisher, scroll publisher
    /// - data sources
    func bind() {
        daysDataSource
            .compactMap { $0 }
            .removeDuplicates(by: { oldValue, newValue in
                oldValue == newValue
            })
            .sink { [weak self] dates in
                guard let self = self else { return }
                self.dayTableViewAdapter?.update(items: dates)
                self.day = self.getCenterCellIndex(tableview: self.dayTableView)
            }.store(in: &cancellables)
        
        finalDateConfiguration
            .compactMap { $0 }
            .removeDuplicates(by: { oldResult, newResult in
                oldResult == newResult
            })
            .sink { (day, month, year) in
                self.outputDate =  self.configureDate(day, month, year)
            }.store(in: &cancellables)
        
        monthTableView.willEndDraggingPublisher
            .sink { [weak self] (velocity, target) in
                guard let self = self else { return }
                self.scrollConfigurator.performScroll(self.monthTableView, velocity, target)
            }.store(in: &cancellables)
        
        yearTableView.willEndDraggingPublisher
            .sink { [weak self] (velocity, target) in
                guard let self = self else { return }
                self.scrollConfigurator.performScroll(self.yearTableView, velocity, target)
            }.store(in: &cancellables)
        
        dayTableView.willEndDraggingPublisher
            .sink { [weak self] (velocity, target) in
                guard let self = self else { return }
                self.scrollConfigurator.performScroll(self.dayTableView, velocity, target)
            }.store(in: &cancellables)
        
        yearTableView.didScrollPublisher
            .sink { [unowned self] _ in
                year = getCenterCellIndex(tableview: yearTableView)
            }.store(in: &cancellables)
        
        monthTableView.didScrollPublisher
            .sink { [unowned self] _ in
                month = getCenterCellIndex(tableview: monthTableView)
            }.store(in: &cancellables)
        
        dayTableView.didScrollPublisher
            .sink { [unowned self] _ in
                day = getCenterCellIndex(tableview: dayTableView)
            }.store(in: &cancellables)
    }
    
    /// Method will configure current date for data sources
    /// - all table views will scroll to configured date
    /// - Parameter completion: Void with no arguments, just as a result of the method
    func configureCurrentDate(completion: @escaping () -> Void) {
        let date = inputDate ?? Date()
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        let year = calendarDate.year ?? (yearDataSource.last ?? 2004)
        let month = calendarDate.month ?? 1
        
        yearDataSource = dateConfigurator.getYears()
        monthsDataSource = dateConfigurator.getMonths()
        daysDataSourceContainer = dateConfigurator.getAllDays(month: month, year: year)
        
        yearTableAdapter?.update(items: yearDataSource)
        monthTableViewAdapter?.update(items: monthsDataSource)
        dayTableViewAdapter?.update(items: daysDataSourceContainer)
        
        let monthIndex = (calendarDate.month ?? 1) - 1
        let yearIndex = (yearDataSource.firstIndex(of: calendarDate.year ?? yearDataSource.last ?? 1) ?? 1)
        let dayIndex = (calendarDate.day ?? 1) - 1
        
        let yearIndexPath = IndexPath(row: yearIndex, section: 0)
        let monthIndexPath = IndexPath(row: monthIndex, section: 0)
        let dayIndexPath = IndexPath(row: dayIndex, section: 0)
        
        // WORKAROUND
        // - due to issues with initializing
        yearTableView.alpha = 0.2
        monthTableView.alpha = 0.2
        dayTableView.alpha = 0.2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.yearTableView.scrollToRow(at: yearIndexPath, at: .top, animated: true)
            self.monthTableView.scrollToRow(at: monthIndexPath, at: .top, animated: true)
            self.dayTableView.scrollToRow(at: dayIndexPath, at: .top, animated: true)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.02, options: .curveEaseInOut) {
            self.yearTableView.alpha = 1
            self.monthTableView.alpha = 1
            self.dayTableView.alpha = 1
        } completion: { _ in
            completion()
        }
    }
    
    /// Method will get indexPath for cell that is closest to table view center
    /// - Parameter tableview: UITableview
    /// - Returns: IndexPath for row at visible point in the center of table view
    private func getCenterCellIndex(tableview: UITableView) -> IndexPath? {
        let rect = CGRect(origin: tableview.contentOffset, size: tableview.bounds.size)
        let visiblePoint = CGPoint(x: rect.midX, y: rect.midY)
        return tableview.indexPathForRow(at: visiblePoint)
    }
    
    /// Method to configure date for output
    /// - Parameters:
    ///   - day: Int
    ///   - month: Int
    ///   - year: Int
    /// - Returns: returns Date object
    private func configureDate(_ day: Int?, _ month: Int?, _ year: Int?) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = (day ?? 1) + 1
        return calendar.date(from: dateComponents) ?? nil
    }
}
