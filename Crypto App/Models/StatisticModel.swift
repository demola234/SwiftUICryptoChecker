//
//  StatisticModel.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 16/07/2024.
//

import Foundation


struct StatisticModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percertageChange: Double?
    
    init(title: String, value: String, percertageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percertageChange = percertageChange
    }
}
