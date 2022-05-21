//
//  BirthdayPickerComponentView.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 21.04.2022.
//

import Combine
import CombineCocoa
import UIKit

final class BirthdayPickerTextField: InsetTextField {
    
    private var cancellables: Set<AnyCancellable> = []
    private let dateFormat = "d MMM yyyy"
    
    private lazy var rightButton: UIButton = {
        let view = IncreasedHitPointButton()
        view.setImage(UIImage(named: "Arrow"), for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 13)
        return view
    }()
    
    private lazy var tappableView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var datePicker: DialogDatePickerView?
    
    private let tapGesture = UITapGestureRecognizer()
    
    /// Tap recognizer transformation Publisher
    private var tapRecognizer: AnyPublisher<Void, Never> {
        tapGesture.tapPublisher.map({ _ in () }).append(Just( () )).eraseToAnyPublisher()
    }
    
    /// Button transformation Publisher
    private var buttonTapped: AnyPublisher<Void, Never> {
        rightButton.tapPublisher.eraseToAnyPublisher()
    }
    
    private var didTapView: AnyPublisher<Void, Never> {
        Publishers.Merge(tapRecognizer, buttonTapped).eraseToAnyPublisher()
    }
    
    var dateOutput: AnyPublisher<String?, Never> {
        $currentDate.eraseToAnyPublisher()
    }
    
    @Published private var currentDate: String? = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bind()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        bind()
    }
    
    private func bind() {
        didTapView.sink { [weak self] _ in
            guard let self = self else { return }
            // TODO: - Change input date
            let date = self.text?.toDate(.custom(self.dateFormat))
            self.datePicker = DialogDatePickerView(inputDate: date)
            self.datePicker?.show() { [weak self] date in
                guard let date = date else {
                    self?.datePicker = nil
                    return
                }
                self?.currentDate = date.toString(.custom(self?.dateFormat ?? ""))
            }
        }.store(in: &cancellables)
        
        $currentDate
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                self?.text = date
            }.store(in: &cancellables)
    }
    
    private func setupUI() {
        rightViewMode = .always
        rightView = rightButton
        isSecureTextEntry = false
        
        textContentType = .none
        autocapitalizationType = .none
        autocorrectionType = .no
        smartDashesType = .no
        smartInsertDeleteType = .no
        smartQuotesType = .no
        spellCheckingType = .no
        keyboardType = .default
        returnKeyType = .done
        enablesReturnKeyAutomatically = true
        clearButtonMode = .never
        
        placeholder = "DD/ MMM/ YYYY"
        
        addSubview(tappableView)
        bringSubviewToFront(tappableView)
        
        tappableView.bindFrameToSuperview()
        
        tappableView.addGestureRecognizer(tapGesture)
    }
}
