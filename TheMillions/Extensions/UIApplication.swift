//
//  UIApplication.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/20.
//

import Foundation
import UIKit

extension UIApplication {
    // dismiss keyboard
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
