//
//  PortfolioView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/21.
//

import SwiftUI

struct PortfolioView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: Coin? = nil
    @State private var amount: String = ""
    @State private var showSave = false
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    } //: If coin selected
                } //: VStack
            } //: ScrollView
            .navigationTitle("Edit Portfolio")
            
            .toolbar {
                dismissButton()
                saveButton()
            }
            .onChange(of: vm.searchText) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        } //: NavView
    }
    
    func dismissButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.callout)
            }
        }
    }
    func saveButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 10) {
                Image(systemName: "checkmark")
                    .opacity(showSave ? 1.0 : 0.0)
                if (selectedCoin != nil && selectedCoin?.currentHoldings != Double(amount)) {
                    Button {
                        saveButtonPressed()
                    } label: {
                        Text("Save".uppercased())
                    } //: Button
                } //: IF
            } //: HStack
            .font(.headline)
        }
    }
    private func getCurrentValue() -> Double {
        if let amount = Double(amount) {
            return amount * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
}
extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .opacity(selectedCoin?.id == coin.id ? 0.5 : 1)
                        .overlay(selectedCoin?.id == coin.id ?
                                 Image(systemName: "checkmark.circle.fill")
                                    .offset(x: 20, y: -40)
                                    .foregroundColor(.theme.accent) :
                                    Image(systemName: "checkmark.circle.fill")
                                    .offset(x: 20, y: -40)
                                    .foregroundColor(.clear)
                        )
                }
            }
            .padding(.leading)
        } //: ScrollView
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.currencyTo2Digits() ?? "")
            } //: HStack
            Divider()
            HStack {
                Text("Holdings:")
                Spacer()
                TextField("Ex: 1.4", text: $amount)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            } //: HStack
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().currencyTo2Digits())
            } //: HStack
        } //: VStack
        .animation(.none)
        .padding()
        .font(.headline)
    }
    private func saveButtonPressed() {
        guard let coin = selectedCoin else { return }
        guard let amount = Double(amount) else { return }
        
        // save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        // show check
        withAnimation(.easeIn) {
            showSave = true
            removeSelectedCoin()
        }
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showSave = false
            }
        }
    }
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}
