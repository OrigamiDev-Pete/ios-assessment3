//
//  AppState.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import Foundation

class AppState {
    static var shared = AppState()
    
    var currentUser: User?
    private var _token: String?
    var token: String? {
        get { _token }
        set {
            _token = newValue
            if _token == nil {
                UserDefaults.standard.removeObject(forKey: "token")
            } else {
                UserDefaults.standard.set(_token, forKey: "token")
            }
        }
    }
}
