//
//  SignUpViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 9/6/2023.
//

import UIKit

class SignUpViewController: UIViewController {

    var apiService: APIService!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUpPressed(_ sender: UIButton) {
        
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        guard let phoneNumber = phoneNumberTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextField.text else { return }
        
        if password != confirmPassword { return }
        
        let registration = RegisterDto(
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            password: password
        )
        
        Task.init {
            let token: String? = await apiService.register(registration: registration)
            if let token = token {
                AppState.shared.token = token
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func onBackToSignInPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
