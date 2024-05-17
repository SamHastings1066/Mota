//
//  View+Ext.swift
//  Mota
//
//  Created by sam hastings on 20/03/2024.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    @MainActor func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


protocol ViewLogging {
    func logViewName()
}

extension ViewLogging where Self: View {
    func logViewName() {
        print("\(Self.self) is created")
    }
}

struct LoggerModifier: ViewModifier {
    let viewName: String

    func body(content: Content) -> some View {
        content
            .onAppear {
                print("\(viewName) is created")
            }
    }
}

extension View {
    func logCreation() -> some View {
        modifier(LoggerModifier(viewName: "\(type(of: self))"))
    }
}
