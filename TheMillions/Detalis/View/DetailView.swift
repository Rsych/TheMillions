//
//  DetailView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/22.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    init(coin: Binding<Coin?>) {
        _coin = coin
        print("Itit detail loading view for \(coin.wrappedValue?.name)")
    }
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
            
        } //: ZStack
    }
}

struct DetailView: View {
    // MARK: - Properties
    @StateObject private var vm: DetailViewModel
    private let column: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Itit detail view for \(coin.name)")
    }
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Hi")
                    .frame(height: 150)
                
                overViewTitle
                Divider()
                overViewGrid
                additionalTitles
                Divider()
                additionalViewGrid
            } //: VStack
            .padding()
        } //: ScrollView
        .navigationTitle(vm.coin.name)
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: Coin.example)
        }
    }
}

extension DetailView {
    private var overViewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitles: some View {
        Text("Additional Detail")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overViewGrid: some View {
        LazyVGrid(columns: column, alignment: .leading, spacing: 30, pinnedViews: []) {
            ForEach(vm.overviewStats) { stat in
                StatsView(stats: stat)
            }
        } //: LazyVGrid
    }
    
    private var additionalViewGrid: some View {
        LazyVGrid(columns: column, alignment: .leading, spacing: 30, pinnedViews: []) {
            ForEach(vm.additionalStats) { stat in
                StatsView(stats: stat)
            }
        } //: LazyVGrid
    }
}
