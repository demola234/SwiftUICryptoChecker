//
//  HomeView.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 14/07/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio = false
    @State private var showPortfolioView = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailsView = false

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }

            VStack {
                headerView
                HomeStatView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitleView

                if !showPortfolio {
                    allCoinList
                        .transition(.move(edge: .leading))
                } else {
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }

                Spacer()
            }
        }
        .background(
            NavigationLink(
                destination: CoinDetailsView(coin: $selectedCoin),
                isActive: $showDetailsView,
                label: {
                    EmptyView() // Use EmptyView to avoid visible elements
                }
            )
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    private var headerView: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        print("Info")
                    }
                }

            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .animation(.none)
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }

    private var allCoinList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .refreshable {
            vm.reloadData()
        }
        .listStyle(PlainListStyle())
    }

    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailsView.toggle()
    }

    private var portfolioCoinList: some View {
        List {
            ForEach(vm.portfolioCoins.isEmpty ? vm.allCoins : vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }

    private var columnTitleView: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rankReversed || vm.sortOption == .rank) ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 180 : 0))
                Spacer()
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }

            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ? 1 : 0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            Spacer()

            HStack {
                Text("Price")
                    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)

                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 180 : 0))
                Button(action: {
                    withAnimation(.spring()) {
                        vm.reloadData()
                    }
                }) {
                    Image(systemName: "goforward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 13, height: 10)
                        .foregroundColor(Color.theme.secondaryText)
                }
                .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0))
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
