//
//  PorfolioView.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 16/07/2024.
//

import SwiftUI

struct PortfolioView: View {
    @State private var selectedCoin: CoinModel? = nil
    @EnvironmentObject private var vm: HomeViewModel
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoViewList
                    
                    if selectedCoin != nil {
                        porfolioInputInformation
                        }
                        
                    
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton
                }
                
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
           
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}


extension PortfolioView {
    private var coinLogoViewList: some View {
        ScrollView(.horizontal, showsIndicators: false, content:  {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    PortfolioCoinRowView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                updateSelectedCoin(coin: coin)
                            }
                            
                        }
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        })
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
       selectedCoin = coin
        
        if let porfolioCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}),
            let amount = porfolioCoin.currentHoldings {
                quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        guard let quantity = Double(quantityText) else { return 0 }
        return (quantity * (selectedCoin?.currentPrice ?? 0))
    }
    
    private var porfolioInputInformation: some View {
        VStack {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyString() ?? "")
            }
            Divider()
            HStack {
                Text("Amount Holding")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.theme.accent)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyString())
            }
        }
        .animation(.none, value: true)
        .padding()
        .font(.headline)
    }
    
    
    private var trailingNavBarButton: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0)
           
        }
        .font(.headline)
        .foregroundColor(.theme.accent)
        
    }
    
    private func saveButtonPressed() {
        guard selectedCoin != nil else { return}
        
        vm.updatePortfolio(coin: selectedCoin!, amount: Double(quantityText) ?? 0)
        
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
            UIApplication.shared.endEditing()
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        quantityText = ""
        vm.searchText = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut) {
                showCheckmark = false
            }
        }
    }
 }
