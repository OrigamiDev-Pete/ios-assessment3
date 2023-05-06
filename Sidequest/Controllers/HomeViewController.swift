//
//  ViewController.swift
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
    }
}

