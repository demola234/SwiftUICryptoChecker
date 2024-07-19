//
//  PortfolioCoinRowView.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 17/07/2024.
//

import SwiftUI

struct PortfolioCoinRowView: View {
    let coin: CoinModel
    
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 45, height: 45)
            
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
            
            
        }
    }
}

struct PortfolioCoinRowView_Previews: PreviewProvider {
    static var previews: some View {
    PortfolioCoinRowView(coin: dev.coin)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
}
        }
