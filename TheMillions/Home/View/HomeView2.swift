//
//  HomeView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import SwiftUI

struct HomeView2: View {
    // MARK: - Properties
    @EnvironmentObject private var vm: HomeViewModel
    
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = true
    @EnvironmentObject private var appLockVM: AppLockViewModel
    @EnvironmentObject var dataController: DataController
    
    @State private var showPortfolioStat: Bool = true
    @State var selectedTab = 0
    
    @State private var showPortfolioView: Bool = false
    @State private var showSettingsView: Bool = false
    
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView: Bool = false
    
    
    
    // MARK: - Body
    var body: some View {
        //        ZStack {
        //            if !appLockVM.isAppLockEnabled || appLockVM.isAppUnLocked {
        ZStack(alignment: .bottom) {
            // MARK: - Background
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, onDismiss: {
                    selectedTab = 0
                }) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            // MARK: - Content
            
            GeometryReader { geo in
                
                VStack {
                    homeHeader
                    HomeStatsView(showPortFolio: $showPortfolioStat)
                    SearchBarView(searchText: $vm.searchText)
                    
                    columnTitles(geo: geo)
                    
                    switch selectedTab {
                    case 0:
                        portFolioMainView
                            .onAppear {
                                showPortfolioStat = true
                            }
                    case 1:
                        allCoinList
                            .onAppear {
                                showPortfolioStat = false
                            }
                    default:
                        allCoinList
                            .onAppear {
                                showSettingsView.toggle()
                                selectedTab = 0
                            }
                    }
                    Spacer()
                } //: VStack
                .sheet(isPresented: $showSettingsView, content: {
                    SettingsView()
                })
            } //: Geo
            //            .zIndex(1.0)
            
            FloatingTabBar(selected: $selectedTab)
        } //: ZStack
        //        .padding(.top)
        //            } else {
        //                LockedView()
        //                }
        //        } //: ZStack appLock
        //        .onAppear {
        //            // if 'isAppLockEnabled' value true, then immediately do the app lock validation
        //            if appLockVM.isAppLockEnabled {
        //                appLockVM.appLockValidation()
        //            }
        //        }
        // To save resources, instead using normal NavLink which init multiple views, used custom lazy link
        .background(
            NavigationLink(isActive: $showDetailView, destination: {
                DetailLoadingView(coin: $selectedCoin)
            }, label: {
                EmptyView()
            })
        ) //: Background
    }
}

extension HomeView2 {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: "plus")
                .animation(.none, value: 0)
                .onTapGesture {
                    showPortfolioView.toggle()
                }
                .background(CircleButtonAnimationView(animation: $showPortfolioStat))
            Spacer()
            Text(selectedTab == 0 ? "Portfolio" : "Live prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
            Spacer()
//            CircleButtonView(iconName: "chevron.right")
//                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
//                .onTapGesture {
//                    withAnimation(.spring()) {
//                        showPortfolio.toggle()
//                    }
//                }
            Spacer()
        }
        .padding(.horizontal)
    }
    private func columnTitles(geo: GeometryProxy) -> some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOptions == .rank || vm.sortOptions == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOptions == .rank ? 0 : 180))
            } //: HStack
            .onTapGesture {
                withAnimation {
                    vm.sortOptions = vm.sortOptions == .rank ? .rankReversed : .rank
                }
                //                            // Same but short
                //                            if vm.sortOptions == .rank {
                //                                vm.sortOptions = .rankReversed
                //                            } else {
                //                                vm.sortOptions = .rank
                //                            }
            }
            Spacer()
            if selectedTab == 0 {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOptions == .holdings || vm.sortOptions == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOptions == .holdings ? 0 : 180))
                } //: HStack
                .onTapGesture {
                    withAnimation {
                        vm.sortOptions = vm.sortOptions == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOptions == .price || vm.sortOptions == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOptions == .price ? 0 : 180))
            } //: HStack
            .onTapGesture {
                withAnimation {
                    vm.sortOptions = vm.sortOptions == .price ? .priceReversed : .price
                }
            }
            
            .frame(width: geo.size.width / 3, alignment: .trailing)
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360: 0), anchor: .center)
            
        } //: HStack
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
    private var allCoinList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowListView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 30, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            } //: Loop
        } //: List
        .refreshable {
            withAnimation(.linear(duration: 2.0)) {
                vm.reloadData()
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowListView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 30, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            } //: Loop
        } //: List
        .refreshable {
            withAnimation(.linear(duration: 2.0)) {
                vm.reloadData()
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinEmpty: some View {
        Text("Please add crypto assets to your portfolio. Click the + button to get started!")
            .font(.callout)
            .foregroundColor(.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(10)
    }
    private var portFolioMainView: some View {
        ZStack(alignment: .top) {
            if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                portfolioCoinEmpty
            } else {
                portfolioCoinList
            }
        } //: ZStack
    }
    
    // segue to detail view
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}

struct HomeView2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView2()
            //                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
        }
        .environmentObject(HomeViewModel())
        .environmentObject(AppLockViewModel())
    }
}
