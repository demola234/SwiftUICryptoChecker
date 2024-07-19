//
//  StatisticView.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 16/07/2024.
//

import SwiftUI

struct StatisticView: View {
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment:.leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption)
                    .rotationEffect(Angle(degrees: stat.percertageChange ?? 0 >= 0 ? 0 : 180))
                Text(stat.percertageChange?.asPercentString() ?? "")
                    .font(.caption2)
                    .bold()
            }
            .foregroundColor(stat.percertageChange ?? 0 >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percertageChange ?? 0 == 0 ? 0.0 : 1.0)
          
        }
    }
}


struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: dev.homeVM.statistics[0])
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            StatisticView(stat: dev.homeVM.statistics[1])
                .previewLayout(.sizeThatFits)
            
            StatisticView(stat: dev.homeVM.statistics[2])
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
