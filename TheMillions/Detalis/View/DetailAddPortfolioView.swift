//
//  DetailAddPortfolioView.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/03/10.
//

import SwiftUI

struct DetailAddPortfolioView: View {
    // MARK: - Properties
    @Binding var showAddToPortfolio: Bool
    @Binding var selectedCoin: Coin?
    @State private var quantyHoldings: String = ""
    @EnvironmentObject private var vm: HomeViewModel
    @EnvironmentObject var dataController: DataController
    init(coin: Binding<Coin?>, showAddToPortfolio: Binding<Bool>) {
        _selectedCoin = coin
        _showAddToPortfolio = showAddToPortfolio
    }
    // MARK: - Body
    var body: some View {
        VStack {
            assetDescription
            
            if selectedCoin?.currentHoldings != nil {
                editAmount
            } else {
                addEmptyAmount
            }
            
            doneButton
            

        }
        .padding()
        .onAppear(perform: {
            updateSelectedCoin(coin: selectedCoin!)
            UITableView.appearance().backgroundColor = .clear
        })
        .frame(height: UIScreen.main.bounds.height / 2)
    }
    func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id } ),
           let amount = portfolioCoin.currentHoldings {
            quantyHoldings = "\(amount)"
        } else {
            quantyHoldings = ""
        }
    }
    private func getCurrentValue() -> Double {
        //        guard let currentHoldings = selectedCoin?.currentHoldings else { return 0.0 }
        if let amount = Double(quantyHoldings) {
            return amount * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    private func saveButtonPressed() {
        guard let coin = selectedCoin else { return }
        guard let amount = Double(quantyHoldings) else { return }
        
        // save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // hide keyboard
        UIApplication.shared.endEditing()
        print(coin.id)
        print(amount)
    }
    func deleteCoin() {
        guard let coin = selectedCoin else { return }
        
        vm.deleteCoinFromPort(coin: coin)
        print(coin.currentHoldings)
    }
}
// MARK: - Preview
struct DetailAddPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAddPortfolioView(coin: .constant(Coin.example), showAddToPortfolio: .constant(true))
            .previewLayout(.sizeThatFits)
            .environmentObject(HomeViewModel())
        
        DetailAddPortfolioView(coin: .constant(Coin.example), showAddToPortfolio: .constant(true))
            .previewLayout(.sizeThatFits)
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}

// MARK: - Extension

extension DetailAddPortfolioView {
    private var assetDescription: some View {
        HStack {
            CoinLogoView(coin: selectedCoin!)
            Spacer()
            VStack(alignment: .trailing) {
                HStack {
                    Text("Current holding")
                        .foregroundColor(.secondary)
                    Text(selectedCoin?.currentHoldings?.numberTo6Digits() ?? "")
                }
                HStack {
                    Text("Current value")
                        .foregroundColor(.secondary)
                    Text(selectedCoin?.currentHoldingValue.currencyTo6Digits() ?? "")
                }
            }
        }
    } //: AssetDescription
    
    private var doneButton: some View {
        Button {
            showAddToPortfolio = false
            saveButtonPressed()
            
        } label: {
            Text("Done")
                .frame(maxWidth:.infinity)
                .padding()
                .accentColor(.white)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 14.0, style: .continuous))
        } //: Button
        .frame(maxWidth: 200.0)
        .padding()
        .offset(y: UIScreen.main.bounds.height / 8)
    }
    
    private var editAmount: some View {
        Form {
            HStack {
                Text("Amount")
                Spacer()
                TextField("Ex: 1.4", text: $quantyHoldings)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            } //: HStack
            .padding()
            HStack {
                Text("Price")
                Spacer()
                Text(getCurrentValue().currencyTo6Digits())
            } //: HStack
            .padding()
        }
    }
    private var addEmptyAmount: some View {
        Form {
            HStack {
                Text("Amount to add")
                Spacer()
                TextField("Ex: 1.4", text: $quantyHoldings)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            } //: HStack
            .padding()
            HStack {
                Text("Price")
                Spacer()
                Text(getCurrentValue().currencyTo6Digits())
            } //: HStack
            .padding()
        }
    }
}
