//
//  PickerDataSourceConfigurator.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 03.05.2022.
//

import Foundation

protocol PickerDataSourceConfigurator {
    func configureCurrentDate(completion: @escaping () -> Void)
    func bind()
    var outputDate: Date? { get }
}
