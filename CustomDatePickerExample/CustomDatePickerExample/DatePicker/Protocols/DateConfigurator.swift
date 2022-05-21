//
//  DateConfigurator.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 03.05.2022.
//

import Foundation

protocol DateConfigurator {
    func getAllDays(month: Int, year: Int) -> [Int]
    func getYears() -> [Int]
    func getMonths() -> [Int]
}
