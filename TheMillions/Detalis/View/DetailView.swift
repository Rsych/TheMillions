//
//  DetailView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/22.
//

import SwiftUI
import SwiftUIPullToRefresh
import PartialSheet

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    @EnvironmentObject private var vm: HomeViewModel
    init(coin: Binding<Coin?>) {
        _coin = coin
    }
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
                    .environmentObject(vm)
                    .zIndex(1.0)
            }
        } //: ZStack
        .attachPartialSheetToRoot()
    }
}

struct DetailView: View {
    // MARK: - Properties
    @StateObject private var vm: DetailViewModel
    @State private var showMore = false
    @EnvironmentObject private var homeVM: HomeViewModel
//    @StateObject private var homeVM: HomeViewModel
    
    @State private var selectedCoin: Coin? = nil
    @State private var showAddToPortfolio = false
    
    private let column: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
//        _homeVM = StateObject(wrappedValue: HomeViewModel())
    }
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack {
                    LineChartView(coin: vm.coin)
                        .padding(.vertical)
                    VStack(alignment: .leading, spacing: 20) {
                        overViewTitle
                        Divider()
                        description
                        overViewGrid
                        additionalTitles
                        Divider()
                        additionalViewGrid
                        websiteLinks
                    } //: VStack
                    .padding()
                } //: VStack
            } //: ScrollView
            addButton
//                .offset(x: -10, y: 0)
                .offset(x: -30, y: -60)
        } //: ZStack
        .partialSheet(isPresented: $showAddToPortfolio, content: {
            DetailAddPortfolioView(coin: $selectedCoin, showAddToPortfolio: $showAddToPortfolio)
                .environmentObject(homeVM)
                
        })
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navTrailingItem
            }
        } //: Toolbar
    } //: Body
    private func segue(coin: Coin) {
        selectedCoin = coin
        showAddToPortfolio.toggle()
    }
    
}

// MARK: - Preview
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
//            DetailView(coin: Coin.example)
            DetailLoadingView(coin: .constant(Coin.example))
                .environmentObject(HomeViewModel())
        }
    }
}

// MARK: - Extension
extension DetailView {
    private var overViewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var description: some View {
        ZStack {
            if let coinDescription = vm.coinDescription,
               !coinDescription.isEmpty {
                VStack {
                    Text(coinDescription.description)
                        .lineLimit(showMore ? nil : 3)
                        .font(.callout)
                        .foregroundColor(.theme.secondaryText)
                    Button {
                        withAnimation(.easeInOut){ showMore.toggle() }
                    } label: {
                        Text(showMore ? "Show less???": "Read more???")
                            .tint(.blue)
                            .font(.caption)
                            .padding(.vertical, 4)
                    } //: Button
                    .frame(maxWidth: .infinity, alignment: .leading)
                } //: VStack
                
            }
        } //: ZStack
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
    private var navTrailingItem: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        } //: HStack
    }
    
    private var websiteLinks: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            if let redditString = vm.redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
        } //: VStack
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
    private var addButton: some View {
        Button {
            segue(coin: vm.coin)
        } label: {
            CircleButtonView(iconName: "plus").opacity(0.8)
        }
    }
}

// MARK: - RefreshableScrollView if needed
//            RefreshableScrollView(onRefresh: { done in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    vm.reloadData()
//                    done()
//                }
//            }, progress: { state in // HERE
//                RefreshActivityIndicator(isAnimating: state == .primed || state == .loading) {
//                    $0.hidesWhenStopped = true }
//            }) {
//                // content here
//            } //: RefreshableScrollView
