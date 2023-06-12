//
//  AddFriendViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import UIKit

class AddFriendViewController: UIViewController {
    
    var onAddDelegate: () -> Void = {}
    
    @IBOutlet weak var addFriend: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    var apiService: APIService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
    }
    
    
    @IBAction func firstNameFriend(_ sender: UITextField) {
        addFriend.isEnabled = sender.text != "" && lastNameTextField.text != "" && phoneNumberTextField.text != ""
    }
    
    @IBAction func lastNameFriend(_ sender: UITextField) {
        addFriend.isEnabled = sender.text != "" && firstNameTextField.text != "" && phoneNumberTextField.text != ""
    }
    
    @IBAction func phoneNumberFriend(_ sender: UITextField) {
        addFriend.isEnabled = sender.text != "" && firstNameTextField.text != "" && lastNameTextField.text != ""
    }
    
    
    @IBAction func addFriendPressed(_ sender: UIButton) {
        
//        let questFriend = User(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, phoneNumber: phoneNumberTextField.text!, friendIds: [])
//        apiService.addUser(questFriend)
//        apiService.addFriend(userId: AppState.shared.currentUser!.id, friendFullName: questFriend.fullName, friendPhoneNumber: questFriend.phoneNumber)
        Task.init() {
            await apiService.sendFriendRequest(phoneNumber: phoneNumberTextField.text!)
        }
        
        self.dismiss(animated: true)
    }
    
    // MARK: - Navigation
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        onAddDelegate()
        super.dismiss(animated: flag)
    }

     
    
    

}
