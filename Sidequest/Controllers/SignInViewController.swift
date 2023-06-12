//
//  SignInViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 9/6/2023.
//

import UIKit

class SignInViewController: UIViewController {
    var apiService: APIService!

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignInPressed(_ sender: UIButton) {
        
        Task.init() {
            let token = await apiService.login(phoneNumber: phoneNumberTextField.text!,
                                               password: passwordTextField.text!)
            if let token = token {
                AppState.shared.token = token
                AppState.shared.currentUser = User(response: await apiService.getUser()!)
                navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
