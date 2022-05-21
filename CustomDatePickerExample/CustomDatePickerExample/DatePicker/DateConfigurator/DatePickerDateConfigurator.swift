//
//  DatePickerDateConfigurator.swift
//  Fabnite
//
//  Created by Evhen Petrovskyi on 03.05.2022.
//

import UIKit

final class DatePickerDateConfigurator: DateConfigurator {
    
    /// Get months from DOBPickerMonthType enum
    /// - Returns: [Int(1...12)]
    func getMonths() -> [Int] {
        Array(DOBPickerMonthType.allCases.map { $0.rawValue })
    }
    
    /// Method to configure number of days in month
    /// - also based on leap year
    /// - Parameters:
    ///   - month: Int (1...12)
    ///   - year: simple Year
    /// - Returns: [Int] as days in month
    func getAllDays(month: Int, year: Int) -> [Int] {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        var array: [Date] = []
        var formattedArray: [Int] = []
        
        for day in 1...numDays {
            let dateString = "\(year) \(month) \(day)"
            if let date = formatter.date(from: dateString) {
                array.append(date)
            }
        }
        
        formatter.dateFormat = "dd"
        
        array.forEach {
            formattedArray.append(Int(formatter.string(from: $0)) ?? 1)
        }
        
        return formattedArray
    }
    
    /// Method to configure amount of years in data source
    /// - Returns: [Int] as Years form and to
    func getYears() -> [Int] {
        let datePicker = UIDatePicker()
        
        var components = DateComponents()
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.year = 0
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        var array: [Int] = []
        var counter: Int = 0
        
        var formattedStartYear: Int = 1900
        var formattedEndYear: Int = 2100
        
        let format = DateFormatter()
        
        format.dateFormat = "yyyy"
        
        formattedStartYear = Int(format.string(from: datePicker.minimumDate!)) ?? 1900
        formattedEndYear = Int(format.string(from: datePicker.maximumDate!)) ?? 2100
        
        for _ in formattedStartYear...formattedEndYear {
            let newYear = formattedStartYear + counter
            array.append(newYear)
            counter += 1
        }
        
        return array
    }
}
