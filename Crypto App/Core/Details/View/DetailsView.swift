//
//  DetailsView.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 17/07/2024.
//

import SwiftUI



struct CoinDetailsView: View {
    
    @Binding var coin: CoinModel?
    
    init(coin: Binding<CoinModel?>) {
        self._coin = coin
    }
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailsView(coin: coin)
            }
        }
    }
}

struct DetailsView: View {
    
    let coin: CoinModel?
    @StateObject var vm : CoinDetailsViewModel
    @State private var showFullDescription: Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private var spacing: CGFloat = 30
    
    init(coin: CoinModel?) {
        self.coin = coin
        _vm = StateObject(wrappedValue: CoinDetailsViewModel(coin: coin!))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coinModel!)
                    .padding(.vertical)
            
                VStack(spacing: 20) {
                    overView
                    descriptionView
                    additionalDetails
                    
                    websiteSection
                   
                }
            }
            .padding()
        }
        .navigationTitle(vm.coinModel?.name ?? "")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
                
            }
        }
        
    }
}

    
    
    struct CoinDetailsView_Previews: PreviewProvider {
        static var previews: some View {
            CoinDetailsView(coin: .constant(dev.coin))
        }
}


extension DetailsView {
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coinModel?.symbol.uppercased() ?? "")
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            
            CoinImageView(coin: vm.coinModel!)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overView: some View {
        VStack {
            Text("Overview")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            
            LazyVGrid (columns: columns, alignment: .leading, spacing: spacing,  pinnedViews: []) {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
            
            Divider()
        }
    }
    
    private var additionalDetails: some View {
        VStack {
            Text("Additional Details")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            
            LazyVGrid (columns: columns, alignment: .leading, spacing: spacing,  pinnedViews: []) {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
            
            Divider()
        }
    }
    
    private var websiteSection: some View  {
        VStack(alignment: .leading, spacing: 20) {
            if let website = vm.websiteURL, let url = URL(string: website) {
                Link("Website", destination: url)
                    .accentColor(.green)
            }
            
            if let reddit = vm.redditURL, let url = URL(string: reddit) {
                Link("Reddit", destination: url)
                    .accentColor(.green)
            }
            
            if let whitepaper = vm.whitepaperURL, let url = URL(string: whitepaper) {
                Link("Whitepaper", destination: url)
                    .accentColor(.green)
            }
        }
        .accentColor(.green)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
    private var descriptionView: some View {
        ZStack {
            if let description = vm.description, !description.isEmpty {
                VStack(alignment: .leading) {
                    Text(description)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                    
                    Button(action: {
                        withAnimation(.spring) {
                            showFullDescription.toggle()
                        }
                        
                    }, label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption)
                            .padding(.vertical, 4)
                            .foregroundColor(Color.theme.secondaryText)
                    })
                    .accentColor(.blue)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            
        }
    }
}
