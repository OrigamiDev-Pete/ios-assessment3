//
//  NewQuestViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import UIKit

class NewQuestViewController: UIViewController {

    var onQuestAddedDelegate: () -> Void = {}
    
    var apiService: APIService!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var questCompletionDatePicker: UIDatePicker!
    @IBOutlet weak var selectedFriendLabel: UILabel!
    
    var selectedFriend: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        
        contentTextField.layer.borderColor = UIColor.lightGray.cgColor
        contentTextField.layer.borderWidth = 1
        contentTextField.layer.cornerRadius = 10.0
        
        titleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        questCompletionDatePicker.minimumDate = Date.now
    }
    
    private func showValidationAlert(_ message: String) {
        let alert = UIAlertController(title: "One sec!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    // MARK: Events
    @IBAction func cancelQuest(_ sender: AnyObject) {
        dismiss(animated: true)
    }
    
    @IBAction func addQuest(_ sender: AnyObject) {
        // Validate inputs
        if (titleTextField.text == nil || titleTextField.text!.isEmpty) {
            showValidationAlert("Please enter a Quest Title.")
            return
        }
        
        guard let currentUser = AppState.shared.currentUser else { return }
        
        let newQuest = Quest(title: titleTextField.text!, content: contentTextField.text, authorId: currentUser.id, assigned: [], endTime: questCompletionDatePicker.date)
        if let selectedFriend = selectedFriend {
            newQuest.assigned.append(selectedFriend.id)
        }
        
        apiService.addQuest(newQuest)
        onQuestAddedDelegate()
        
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectFriendViewController = segue.destination as? QuestDetailsViewController {
            selectFriendViewController.onFriendSelectDelegate = { (user: User) -> Void in
                self.selectedFriend = user
                self.selectedFriendLabel.text = user.fullName
            }
        }
    }
}
