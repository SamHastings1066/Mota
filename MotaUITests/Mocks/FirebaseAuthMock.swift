//
//  FirebaseAuthMock.swift
//  MotaUITests
//
//  Created by sam hastings on 19/01/2024.
//

import Foundation

class FirebaseAuthMock {
    static func signIn(withEmail email: String, password: String) -> Bool {
        if email == "sam@example.com" && password == "123456" {
            return true
        } else {
            return false
        }
    }
}
