//
//  HomeViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 5/5/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    var apiService: APIService!
    
    var quests: [Quest] = []
    @IBOutlet weak var allQuestsButton: ListButtonView!
    @IBOutlet weak var todayQuestsButton: ListButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        
        if let currentUser = apiService.login(phoneNumber: "000") {
            AppState.shared.currentUser = currentUser
        } else {
            fatalError("User not found.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       guard let currentUser = AppState.shared.currentUser else { return }
        
        quests = apiService.getQuests(userId: currentUser.id)
        allQuestsButton.amount = quests.count
        
        var todayQuestCount = 0;
        for quest in quests {
            if Calendar.current.isDateInToday(quest.endTime) {
                todayQuestCount += 1
            }
        }
        
        todayQuestsButton.amount = todayQuestCount
    }
    
    // MARK: - Events
    
    @IBAction func onAllQuestsPressed(_ sender: ListButtonView) {
        let questsViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestsViewController") as! QuestsViewController
        questsViewController.quests = quests
        questsViewController.heading = "All"
        
        self.navigationController?.pushViewController(questsViewController, animated: true)
    }
    
    @IBAction func onTodayQuestsPressed(_ sender: ListButtonView) {
        let questsViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestsViewController") as! QuestsViewController
        
        var todaysQuests: [Quest] = []
        for quest in quests {
            if Calendar.current.isDateInToday(quest.endTime) {
                todaysQuests.append(quest)
            }
        }
        questsViewController.quests = todaysQuests
        questsViewController.heading = "Today"
        
        self.navigationController?.pushViewController(questsViewController, animated: true)
    }
    
}

