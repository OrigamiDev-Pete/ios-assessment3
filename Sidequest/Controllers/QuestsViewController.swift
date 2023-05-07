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
    
    var heading: String = "Title"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        // guard let currentUser = AppState.shared.currentUser else { return }
        
        headingLabel.text = heading
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCell", for: indexPath) as! QuestTableCell
        
        let quest = quests[indexPath.row]
        
        cell.titleLabel.text = quest.title
        cell.contentPreviewLabel.text = quest.content
        let questStatus = quest.status.getStatusUIDetails()
        cell.statusLabel.text = questStatus.1
        cell.statusLabel.textColor = questStatus.0
        
        return cell
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
