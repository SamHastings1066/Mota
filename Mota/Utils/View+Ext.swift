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
    let startTime: DispatchTime
    
    init(viewName: String) {
        self.viewName = viewName
        self.startTime = DispatchTime.now()
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let endTime = DispatchTime.now()
                let creationTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
                print("\(viewName) is created in \(creationTime)s")
            }
    }
}

extension View {
    func logCreation() -> some View {
        modifier(LoggerModifier(viewName: "\(type(of: self))"))
    }
}
