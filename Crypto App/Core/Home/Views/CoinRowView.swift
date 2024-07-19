//
//  CoinRowView.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 14/07/2024.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack {
            leftColumn
            Spacer()
            if showHoldingsColumn {
                middleColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .padding()
        .background(
            Color.theme.background.opacity(0.001)
        )
    }
}


struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
        }
    }
}


extension CoinRowView {
    private var leftColumn: some View {
        HStack (spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
                .padding(.trailing, 8)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .frame(minWidth: 30)
        }
    }
    
    private var middleColumn: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .trailing) {
                Text(coin.currentHoldingsValue.asCurrencyString())
                Text((coin.currentHoldings ?? 0).asNumberString())
            }
            .foregroundColor(Color.theme.accent)
        }
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyString())
                .bold()
                .foregroundStyle(Color.theme.accent)
                 Text(coin.priceChangePercentage24H?.asPercentString() ?? "0.00%" )
                .foregroundStyle((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
