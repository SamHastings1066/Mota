//
//  Array+Ext.swift
//  Mota
//
//  Created by sam hastings on 06/06/2024.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
