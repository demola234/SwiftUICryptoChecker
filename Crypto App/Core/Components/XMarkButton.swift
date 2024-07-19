//
//  XMarkButton.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 16/07/2024.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() },
                                            label:  {
            Image(systemName: "xmark")
            .font(.headline)
                                            
                                            })
    }
}

#Preview {
    XMarkButton()
}
