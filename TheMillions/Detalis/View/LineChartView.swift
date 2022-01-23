//
//  LineChartView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/23.
//

import SwiftUI

struct LineChartView: View {
    // MARK: - Properties
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    
    @State private var aniPercent: CGFloat = 0
    
    init(coin: Coin) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? .theme.green : .theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    // MARK: - Body
    var body: some View {
        VStack {
        chartView
            .frame(height: 200)
            .background(chartBackground)
            .overlay(alignment: .leading) { chartYAxis }
            chartDate
        } //: VStack
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    aniPercent = 1.0
                }
            }
        } //: onAppear
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(coin: Coin.example)

    }
}

extension LineChartView {
    private var chartView: some View {
        GeometryReader { geo in
            Path { path in
                for index in data.indices {

                    let xPosition = geo.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geo.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: aniPercent)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
        } //: Geo
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        } //: VStack
    }
    
    private var chartYAxis: some View {
        VStack(alignment: .leading) {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            let price = ((maxY + minY) / 2).formattedWithAbbreviations()
            Text(price)
            Spacer()
            Text(minY.formattedWithAbbreviations())
        } //: VStack
    }
    private var chartDate: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        } //: HStack
    }
}
