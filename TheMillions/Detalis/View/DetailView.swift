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
    @StateObject var vm: DetailViewModel
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Itit detail view for \(coin.name)")
    }
    // MARK: - Body
    var body: some View {
        ZStack {
           Text("Hello")
        } //: ZStack
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: Coin.example)
    }
}
