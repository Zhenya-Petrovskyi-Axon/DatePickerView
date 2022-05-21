//
//  ViewController.swift
//  CustomDatePickerExample
//
//  Created by Ievgen Petrovskiy on 21.05.2022.
//

import UIKit
import Combine
import CombineCocoa

class ViewController: UIViewController {
    @IBOutlet weak var dobTextField: BirthdayPickerTextField!
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    func bind() {
        dobTextField.dateOutput
            .compactMap { $0 }
            .sink { value in
                print(value)
            }.store(in: &cancellables)
    }
    

}

