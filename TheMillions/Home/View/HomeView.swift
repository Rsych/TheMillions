//
//  HomeView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @EnvironmentObject private var vm: HomeViewModel
    
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = true
    @EnvironmentObject private var appLockVM: AppLockViewModel
    @EnvironmentObject var dataController: DataController
    
    @State private var showPortfolio: Bool = false
    
    @State private var showPortfolioView: Bool = false
    @State private var showSettingsView: Bool = false
    
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if !appLockVM.isAppLockEnabled || appLockVM.isAppUnLocked {
        ZStack {
            // MARK: - Background
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            // MARK: - Content
            GeometryReader { geo in
                VStack {
                    homeHeader
                    HomeStatsView(showPortFolio: $showPortfolio)
                    SearchBarView(searchText: $vm.searchText)
                    
                    columnTitles(geo: geo)
                    
                    if !showPortfolio {
                        allCoinList
                            .transition(.move(edge: .leading))
                    } else {
                        portfolioCoinList
                            .transition(.move(edge: .trailing))
                    }
                    Spacer()
                } //: VStack
                .sheet(isPresented: $showSettingsView, content: {
                    SettingsView()
                })
                .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                            .onEnded { value in
                    let horizontalAmount = value.translation.width as CGFloat
                    let verticalAmount = value.translation.height as CGFloat
                    if abs(horizontalAmount) > abs(verticalAmount) {
                        print(horizontalAmount < 0 ? "left swipe" : "right swipe")
                        if horizontalAmount < 0 {
                            withAnimation(.spring()) {
                                showPortfolio = true
                            }
                        } else {
                            withAnimation(.spring()) {
                                showPortfolio = false
                            }
                        }
                    } else {
                        print(verticalAmount < 0 ? "up swipe" : "down swipe")
                    }
                }) //: swipe left & right with animation
                .padding(.top)
            } //: Geo
            
        } //: ZStack
        .padding(.top)
            } else {
                LockedView()
                }
        } //: ZStack appLock
        .onAppear {
            // if 'isAppLockEnabled' value true, then immediately do the app lock validation
            if appLockVM.isAppLockEnabled {
                appLockVM.appLockValidation()
            }
        }
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

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: 0)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                        print(showSettingsView)
                    }
                }
                .background(CircleButtonAnimationView(animation: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
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
            if showPortfolio {
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
    
    // segue to detail view
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
            //                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
        }
        .environmentObject(HomeViewModel())
        .environmentObject(AppLockViewModel())
    }
}
