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
}
