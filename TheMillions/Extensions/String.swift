//
//  String.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/23.
//

import Foundation

extension String {
    var removingHTMLtags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
