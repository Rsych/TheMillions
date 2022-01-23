//
//  StatsView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/20.
//

import SwiftUI

struct StatsView: View {
    // MARK: - Properties
    let stats: Stats
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stats.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            Text(stats.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            HStack {
                Image(systemName: "arrow.up")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stats.percentile ?? 0) >= 0 ? 0 : 180))
                Text(stats.percentile?.percentToString() ?? "")
                    .font(.caption)
                    .bold()
            } //: HStack
            .foregroundColor((stats.percentile ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stats.percentile == nil ? 0.0 : 1.0)
        } //: VStack
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatsView(stats: Stats.example)
                .preferredColorScheme(.dark)
            StatsView(stats: Stats.example2)
            StatsView(stats: Stats.example3)
        }
        .previewLayout(.sizeThatFits)
    }
}
