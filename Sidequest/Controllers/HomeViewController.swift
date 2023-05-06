//
//  HomeViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 5/5/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    var apiService: APIService!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        
        if let currentUser = apiService.login(phoneNumber: "000") {
            AppState.shared.currentUser = currentUser
        } else {
            fatalError("User not found.")
        }
        
        if let currentUser = AppState.shared.currentUser {
            print(currentUser.fullname)
        }

    }
}

