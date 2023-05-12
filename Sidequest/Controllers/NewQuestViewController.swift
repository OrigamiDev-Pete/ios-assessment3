//
//  NewQuestViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import UIKit

class NewQuestViewController: UIViewController {

    var apiService: APIService!
    
    
    @IBOutlet weak var contentTextField: UITextView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBAction func cancelQuest(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addQuest(_ sender: AnyObject) {
        dismiss(animated: true)
        
    }
    
    @IBOutlet weak var addFriendsListButton: UIButton!
    
    
    @IBOutlet weak var questCompletionDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        
        addFriendsListButton.showsMenuAsPrimaryAction  = true
        addFriendsListButton.changesSelectionAsPrimaryAction = true
        
        let optionClosure = {(action: UIAction) in
            if ((action.index(ofAccessibilityElement: (Any).self)) != 0){}
        }
        
        addFriendsListButton.menu = UIMenu(children: [
            UIAction(title: "Add Friend", state: .on, handler: optionClosure),
            UIAction(title: "User 0", handler: optionClosure), //Users need to be pulled from API
            UIAction(title: "User 1", handler: optionClosure),
            UIAction(title: "User 2", handler: optionClosure)
        ])

        contentTextField.layer.borderColor = UIColor.lightGray.cgColor
        contentTextField.layer.borderWidth = 1
        contentTextField.layer.cornerRadius = 10.0
        
        titleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        questCompletionDatePicker.minimumDate = Date.now
        
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
