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
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quests.count
    }
    
    // Create Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCell", for: indexPath) as! QuestTableCell
        
        let quest = quests[indexPath.row]
        
        cell.titleLabel.text = quest.title
        cell.contentPreviewLabel.text = quest.content
        let questStatus = quest.status.getStatusUIDetails()
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
    
    
    // MARK: - Events
    
    @IBAction func toggleEditMode(_ sender: UITapGestureRecognizer) {
        if !tableView.isEditing {
            editButton.image = UIImage.init(systemName: "checkmark")
        } else {
            editButton.image = UIImage.init(systemName: "pencil")
        }
        
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}
