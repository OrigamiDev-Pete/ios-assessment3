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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        guard let currentUser = AppState.shared.currentUser else { return }
        print(currentUser.id)
        quests = apiService.getQuests(userId: currentUser.id)
        print(quests)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCell", for: indexPath) as! QuestTableCell
        cell.title.text = quests[indexPath.row].title
        cell.contentPreview.text = quests[indexPath.row].content
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
