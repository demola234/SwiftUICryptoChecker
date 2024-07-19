//
//  String.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 18/07/2024.
//

import Foundation


extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    
}
