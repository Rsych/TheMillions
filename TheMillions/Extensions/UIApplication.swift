//
//  UIApplication.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/20.
//

import UIKit
import SwiftUI

extension UIApplication {
    // dismiss keyboard
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    // For safeArea
    var keyWindow: UIWindow? {
            connectedScenes
                .compactMap {
                    $0 as? UIWindowScene
                }
                .flatMap {
                    $0.windows
                }
                .first {
                    $0.isKeyWindow
                }
        }
}
// MARK: - SafeAreaInsets
private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
