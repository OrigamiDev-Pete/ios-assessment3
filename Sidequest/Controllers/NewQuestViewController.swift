//
//  NewQuestViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import UIKit

class NewQuestViewController: UIViewController {

    var onModalCompleteDelegate: () -> Void = {}
    var onNewQuestDelegate: (_ newQuest: Quest?) -> Void = { newQuest in }
    
    var apiService: APIService!
    
    @IBOutlet weak var addQuestButton: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var questCompletionDatePicker: UIDatePicker!
    @IBOutlet weak var selectedFriendLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var updateQuestButton: UIButton!
    
    var selectedFriend: User? = nil
    var quest: Quest? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        
        contentTextField.layer.borderColor = UIColor.lightGray.cgColor
        contentTextField.layer.borderWidth = 1
        contentTextField.layer.cornerRadius = 10.0
        
        titleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        // Hack to remove milliseconds
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let formattedDate = formatter.string(from: Date.now)
        
        questCompletionDatePicker.minimumDate = formatter.date(from: formattedDate)
        
        // Auto fill selected friend when making a quest from the friend quests list
        if let selectedFriend = selectedFriend {
            selectedFriendLabel.text = selectedFriend.fullName
        }
        
        // Editing a quest
        guard let currentUser = AppState.shared.currentUser else { return }
        if let quest = quest {
            navItem.title = "Edit Quest"
            navItem.rightBarButtonItem?.isHidden = true
            
            // Only allow editing of quest if status is active or overdue
            let questStatus = quest.getStatus(fromUserPerspective: currentUser)
            if questStatus == .active || questStatus == .overdue {
                updateQuestButton.isHidden = false
            }
            
            // Only allow completing on active quests
            if quest.compeletedBy == nil && questStatus == .active {
                completeButton.isHidden = false
            }
            
            titleTextField.text = quest.title
            contentTextField.text = quest.content
            questCompletionDatePicker.date = quest.endTime
            if quest.assigned.count > 0 {
                selectedFriend = apiService.getUser(userId: quest.assigned[0])
                selectedFriendLabel.text = selectedFriend?.fullName
            }
        }
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
        
        let newQuest = Quest(title: titleTextField.text!, content: contentTextField.text, authorId: currentUser.id, assigned: [], completedBy: nil, endTime: questCompletionDatePicker.date)
        if let selectedFriend = selectedFriend {
            newQuest.assigned.append(selectedFriend.id)
        }
        
        Task.init() {
            await apiService.addQuest(newQuest)
            
            onNewQuestDelegate(newQuest)
            dismiss(animated: true)
        }
    }
    
    @IBAction func onCompletePressed(_ sender: UIButton) {
        guard let currentUser = AppState.shared.currentUser else { return }
        // Quest should be not nil to reach here
        quest!.compeletedBy = currentUser.id
        
        Task.init() {
            await apiService.updateQuest(quest!)
            
            onModalCompleteDelegate()
            dismiss(animated: true)
            
        }
        
    }
    
    @IBAction func onUpdateQuestPressed(_ sender: UIButton) {
        // Quest should be not nil to reach here
        quest!.title = titleTextField.text ?? ""
        quest!.content = contentTextField.text
        quest!.endTime = questCompletionDatePicker.date
        quest!.assigned = []
        if let selectedFriend = selectedFriend {
            quest!.assigned.append(selectedFriend.id)
        }
        
        Task.init() {
            await apiService.updateQuest(quest!)
            
            onModalCompleteDelegate()
            dismiss(animated: true)
        }
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
