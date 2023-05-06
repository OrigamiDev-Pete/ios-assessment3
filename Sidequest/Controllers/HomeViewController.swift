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
    
    @IBAction func Test(_ sender: Any) {
        print("yep")
    }
    @IBAction func onAllQuestsPressed(_ sender: UITapGestureRecognizer) {
        print("here")
    }
    @IBAction func onTodayQuestsPressed(_ sender: Any) {
        print("ere")
    }
}

