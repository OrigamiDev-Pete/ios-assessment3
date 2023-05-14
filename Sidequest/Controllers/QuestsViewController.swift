//
//  QuestsViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import UIKit

class QuestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var apiService: APIService!
    var quests: [Quest] = []
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var editButton: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var heading: String = "Title"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        // guard let currentUser = AppState.shared.currentUser else { return }
        
        headingLabel.text = heading
        tableView.allowsSelection = true
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quests.count
    }
    
    // Create Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCell", for: indexPath) as! QuestTableCell
        guard let currentUser = AppState.shared.currentUser else { return cell }
        
        let quest = quests[indexPath.row]
        
        cell.titleLabel.text = quest.title
        cell.contentPreviewLabel.text = quest.content
        let questStatus = quest.getStatus(fromUserPerspective: currentUser).getStatusUIDetails()
        cell.statusLabel.textColor = questStatus.0
        cell.statusLabel.text = questStatus.1
        
        return cell
    }
    
    // Delete Row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            apiService.deleteQuest(questId: quests[indexPath.row].id)
            quests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newQuestViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewQuestViewController") as! NewQuestViewController
        
        let quest = quests[indexPath.row]
        
        newQuestViewController.quest = quest
        
        newQuestViewController.onModalCompleteDelegate = { () -> Void in
            tableView.reloadData()
        }
        
        present(newQuestViewController, animated: true)
    }
    
    // MARK: - Events
    
    @IBAction func toggleEditMode(_ sender: UITapGestureRecognizer) {
        if !tableView.isEditing {
            editButton.image = UIImage.init(systemName: "checkmark")
        } else {
            editButton.image = UIImage.init(systemName: "pencil")
        }

        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newQuestViewController = segue.destination as? NewQuestViewController {
            newQuestViewController.onModalCompleteDelegate = { () -> Void in
                self.tableView.reloadData()
            }
        }
    }
}
