//
//  ChartView.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 18/07/2024.
//

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    @State private var currentXPosition: CGFloat = 0
    @State private var showIndicator: Bool = false
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        if priceChange > 0 {
            lineColor = Color.theme.green
            print("Price increased: \(priceChange). Using green color.")
        } else {
            lineColor = Color.theme.red
            print("Price decreased: \(priceChange). Using red color.")
        }
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
            chartXAxis
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeIn(duration: 2)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    for index in data.indices {
                        let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                        let yAxis = maxY - minY
                        let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: 0, y: yPosition))
                        } else {
                            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                        }
                    }
                }
                .trim(from: 0, to: percentage)
                .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
                .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
                .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
                .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
                
                if showIndicator {
                    indicatorView
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let xPosition = value.location.x
                        currentXPosition = xPosition
                        showIndicator = true
                    }
                    .onEnded { _ in
                        showIndicator = false
                    }
            )
        }
    }
    
    private var indicatorView: some View {
        GeometryReader { geometry in
            let index = min(max(Int((currentXPosition / geometry.size.width) * CGFloat(data.count)), 0), data.count - 1)
            let yAxis = maxY - minY
            let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
            
            return VStack {
                Text(data[index].formattedWithAbbreviation())
                    .padding(4)
                    .background(Color.black.opacity(0.75))
                    .cornerRadius(5)
                    .foregroundColor(.white)
                    .position(x: currentXPosition, y: max(yPosition - 20, 0))
                
                Rectangle()
                    .fill(lineColor)
                    .frame(width: 1, height: geometry.size.height)
                    .position(x: currentXPosition, y: geometry.size.height / 2)
            }
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviation())
                .foregroundColor(Color.theme.secondaryText)
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviation())
            Spacer()
            Text(minY.formattedWithAbbreviation())
                .foregroundColor(Color.theme.secondaryText)
            
        }
    }
    
    private var chartXAxis: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
