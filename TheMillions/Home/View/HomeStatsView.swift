//
//  HomeStatsView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/20.
//

import SwiftUI

struct HomeStatsView: View {
    // MARK: - Properties
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortFolio: Bool
    // MARK: - Body
    var body: some View {
//        GeometryReader { geo in
            HStack {
                ForEach(vm.stats) { stat in
                    StatsView(stats: stat)
                        .frame(width: UIScreen.main.bounds.width / 3)
                } //: Loop
            } //: HStack
            .frame(width: UIScreen.main.bounds.width,
                   alignment: showPortFolio ? .trailing : .leading)
//        } //: Geo
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortFolio: .constant(false))
            .previewLayout(.sizeThatFits)
            .environmentObject(HomeViewModel())
    }
}
