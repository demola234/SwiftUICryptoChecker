//
//  UIApplication.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 16/07/2024.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
