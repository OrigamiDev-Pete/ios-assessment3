//
//  AddFriendViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import UIKit

class AddFriendViewController: UIViewController {
    
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
    }
    
    @IBAction func lastNameFriend(_ sender: UITextField) {
    }
    
    @IBAction func phoneNumberFriend(_ sender: UITextField) {
        addFriend.isEnabled = sender.text != ""
    }
    
    
    @IBAction func addFriendPressed(_ sender: UIButton) {
        
        var questFriend = User(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, phoneNumber: phoneNumberTextField.text!, friendIds: [])
        apiService.addUser(user: questFriend)
        apiService.addFriend(userId: AppState.shared.currentUser!.id, friendFullName: questFriend.fullName, friendPhoneNumber: questFriend.phoneNumber)
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
