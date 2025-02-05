//
//  SearchBarView.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 15/07/2024.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.accent)
            
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(Color.theme.secondaryText)
                .disableAutocorrection(true)
                .overlay(Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .foregroundColor(Color.theme.accent)
                    .opacity(searchText.isEmpty ? 0.0 :1.0)
                    .onTapGesture {
                        searchText = ""
                        UIApplication.shared.endEditing()
                    }
                         ,alignment: .trailing
                )
                
                
                
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 10,
                    x: 0.0,
                    y: 0.0
                )
        )
        .padding()
    }
}

#Preview {
    
        SearchBarView(searchText: .constant(""))
            .previewLayout(.sizeThatFits)
           
        
       
}
