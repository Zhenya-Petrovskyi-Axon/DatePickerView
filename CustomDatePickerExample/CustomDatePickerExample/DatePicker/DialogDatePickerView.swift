//
//  DialogDatePickerView.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 22.04.2022.
//

import Combine
import CombineCocoa
import UIKit

//swiftlint:disable all
final class DialogDatePickerView: PublishableMainView {
    
    // MARK: - Typealias
    typealias DatePickerCallback = (Date?) -> Void
    typealias CellType = DatePickerCell
    
    // MARK: - Layout properties
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let hStackInset:  CGFloat = 24
        static let buttonHeight: CGFloat = 32
        static let buttonWidth:  CGFloat = 72
        static let buttonHInset: CGFloat = 24
        static let buttonVInset: CGFloat = 32
        static let tableInset:   CGFloat = CellType.height * 2
        static var cellHeight:   CGFloat { CellType.height }
        
        static var tableViewHeight:      CGFloat = cellHeight * 5
        static let selectionViewCornerR: CGFloat = 6
        
        static let dialogSize:    CGSize = CGSize(width: 298, height: 312)
        static var screenSize:    CGSize { UIScreen.main.bounds.size }
        static let mainFrameRect: CGRect = CGRect(
            x: 0,
            y: 0,
            width: screenSize.width,
            height: screenSize.height
        )
        static let containerRect: CGRect = CGRect(
            x: (screenSize.width - dialogSize.width) / 2,
            y: (screenSize.height - dialogSize.height) / 2,
            width: dialogSize.width,
            height: dialogSize.height
        )
        static let shadowColor:   CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        static let shadowOpacity: Float = 1
        static let shadowRadius:  CGFloat  = 24
        
        static let animationDuration: Double = 0.2
    }
    
    // MARK: - Views
    private var dialogView: UIView!
    
    // MARK: - Variables
    private var callback: DatePickerCallback!
    private var container: UIView?
    
    // MARK: - Buttons
    private lazy var doneButton: AppButton = {
        let button = AppButton(type: .system)
        button.configure(buttonType: .pickerSave)
        return button
    }()
    
    private lazy var cancelButton: AppButton = {
        let button = AppButton(type: .system)
        button.configure(buttonType: .pickerCancel)
        return button
    }()
    
    // MARK: - Selection view
    private lazy var selectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - Table views
    // Day
    private lazy var daysTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset.top = Layout.tableInset
        view.contentInset.bottom = Layout.tableInset
        return view
    }()
    
    // Month
    private lazy var monthTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset.top = Layout.tableInset
        view.contentInset.bottom = Layout.tableInset
        return view
    }()
    
    // Year
    private lazy var yearTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset.top = Layout.tableInset
        view.contentInset.bottom = Layout.tableInset
        return view
    }()
    
    // MARK: - Picker main stack
    private lazy var pickerHStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        return view
    }()
    
    // MARK: - Operation classes
    private var dataSourceConfigurator: PickerDataSourceConfigurator!
    
    // MARK: - Dialog initialization
    init(inputDate: Date?) {
        super.init(frame: UIScreen.main.bounds)
        setupView()
        setupTableViews()
        commonInit(inputDate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionView.layer.cornerRadius = Layout.selectionViewCornerR
        selectionView.layer.cornerCurve = .continuous
    }
    
    private func commonInit(_ inputDate: Date?) {
        
        dataSourceConfigurator = DatePickerDataSourceConfigurator(
            dayTableView: self.daysTableView,
            monthTableView: self.monthTableView,
            yearTableView: self.yearTableView,
            inputDate: inputDate,
            cellHeight: Layout.cellHeight)
        
        dataSourceConfigurator.configureCurrentDate { [weak self] in
            self?.bind()
            self?.dataSourceConfigurator.bind()
        }
    }
    
    private func bind() {
        cancelButton.tapPublisher
            .sink { [weak self] _ in
                self?.close()
            }.store(in: &cancellables)
        
        doneButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.callback(self.dataSourceConfigurator.outputDate ?? Date())
                self.close()
            }.store(in: &cancellables)
    }
    
    /// Create the dialog view, and animate opening the dialog
    /// - Parameter callback: optional Date
    func show(callback: @escaping DatePickerCallback) {
        self.callback = callback
        
        // Add dialog to main window
//        guard let appDelegate = UIApplication.shared.delegate,
//              let window = appDelegate.window else {
//            return
//        }
//
//        window?.addSubview(self)
//        window?.bringSubviewToFront(self)
//        window?.endEditing(true)
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("Could not get scene delegate ")
        }
        
        sceneDelegate.window?.addSubview(self)
        sceneDelegate.window?.bringSubviewToFront(self)
        sceneDelegate.window?.endEditing(true)
        
        // Animation
        UIView.animate(withDuration: Layout.animationDuration, delay: 0, options: .curveEaseInOut) {
            self.backgroundColor = .black.withAlphaComponent(0.6)
            self.dialogView?.layer.opacity = 1
            self.dialogView?.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }
    
    /// Dialog close animation then cleaning and removing the view from the parent
    private func close() {
        let currentTransform = self.dialogView.layer.transform
        
        let startRotation = (self.value(forKeyPath: "layer.transform.rotation.z") as? NSNumber) as? Double ?? 0.0
        let rotation = CATransform3DMakeRotation((CGFloat)(-startRotation + .pi * 270 / 180), 0, 0, 0)
        
        self.dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1))
        self.dialogView.layer.opacity = 1
        
        UIView.animate(withDuration: Layout.animationDuration, animations: {
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            let transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
            self.dialogView.layer.transform = transform
            self.dialogView.layer.opacity = 0
        }, completion: { _ in
            self.subviews.forEach {
                $0.removeFromSuperview()
            }
            self.removeFromSuperview()
            self.setupView()
        })
    }
    
    func setupView() {
        dialogView = createContainerView()
        
        dialogView?.layer.shouldRasterize = true
        dialogView?.layer.rasterizationScale = UIScreen.main.scale
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        dialogView?.layer.opacity = 0.5
        dialogView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        
        backgroundColor = .clear
        
        if let dialogView = dialogView {
            addSubview(dialogView)
        }
    }
    
    /// Creates the container view here: create the dialog, then add the custom content and buttons
    private func createContainerView() -> UIView {
        // For the black background
        self.frame = Layout.mainFrameRect
        
        // This is the dialog's container; we attach the custom content and the buttons to this one
        let container = UIView()
        container.backgroundColor = .white
        container.frame = Layout.containerRect
        
        container.layer.cornerRadius = Layout.cornerRadius
        container.layer.shadowRadius = Layout.cornerRadius
        container.layer.shadowColor = Layout.shadowColor
        container.layer.shadowOpacity = Layout.shadowOpacity
        container.layer.shadowRadius = Layout.shadowRadius
        container.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        addComponentsToView(container)
        
        return container
    }
    
    /// Method will add components to main container view
    /// - Parameter container: UIView as container view
    private func addComponentsToView(_ container: UIView) {
        
        [cancelButton, doneButton, pickerHStack, selectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        container.addSubview(selectionView)
        container.addSubview(cancelButton)
        container.addSubview(doneButton)
        
        [daysTableView, monthTableView, yearTableView].forEach { view in
            pickerHStack.addArrangedSubview(view)
        }
        
        container.addSubview(pickerHStack)
        
        NSLayoutConstraint.activate([
            
            selectionView.leadingAnchor.constraint(equalTo: pickerHStack.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: pickerHStack.trailingAnchor),
            selectionView.heightAnchor.constraint(equalToConstant: Layout.cellHeight),
            selectionView.centerYAnchor.constraint(equalTo: pickerHStack.centerYAnchor),
            selectionView.centerXAnchor.constraint(equalTo: pickerHStack.centerXAnchor),
            
            pickerHStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Layout.hStackInset),
            pickerHStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Layout.hStackInset),
            pickerHStack.topAnchor.constraint(equalTo: container.topAnchor, constant: Layout.hStackInset),
            pickerHStack.heightAnchor.constraint(equalToConstant: Layout.tableViewHeight),
            
            cancelButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight),
            cancelButton.widthAnchor.constraint(equalToConstant: Layout.buttonWidth),
            cancelButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Layout.buttonVInset),
            cancelButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Layout.buttonHInset),
            
            doneButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Layout.buttonHInset),
            doneButton.widthAnchor.constraint(equalToConstant: Layout.buttonWidth),
            doneButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight),
            
        ])
    }
    
    private func setupTableViews() {
        [yearTableView, monthTableView, daysTableView].forEach {
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.isPagingEnabled = false
            $0.decelerationRate = .fast
            $0.bounces = false
            $0.estimatedRowHeight = Layout.cellHeight
        }
    }
}
