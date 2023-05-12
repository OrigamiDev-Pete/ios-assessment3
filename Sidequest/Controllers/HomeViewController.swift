//
//  HomeViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 5/5/2023.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var apiService: APIService!
    
    var friends: [User] = []
    var quests: [Quest] = []
    @IBOutlet weak var allQuestsButton: ListButtonView!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var todayQuestsButton: ListButtonView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = false
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        
        if let currentUser = apiService.login(phoneNumber: "111") {
            AppState.shared.currentUser = currentUser
        } else {
            fatalError("User not found.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       guard let currentUser = AppState.shared.currentUser else { return }
        
        // Populate Quests
        quests = apiService.getQuests(userId: currentUser.id)
        allQuestsButton.amount = quests.count
        
        var todayQuestCount = 0;
        for quest in quests {
            if Calendar.current.isDateInToday(quest.endTime) {
                todayQuestCount += 1
            }
        }
        todayQuestsButton.amount = todayQuestCount
        
        // Populate Friends
        updateFriends()
    }
    
    func updateFriends() {
       guard let currentUser = AppState.shared.currentUser else { return }
        friends = apiService.getFriends(friendIds: currentUser.friendIds)
        friendsTableView.reloadData()
    }
    
    // MARK: - Events
    
    @IBAction func onAddFriendButtonPressed(_ sender: UIButton) {
        let addFriendViewController = storyboard?.instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
        addFriendViewController.onAddDelegate = updateFriends
        present(addFriendViewController, animated: true)
    }
    
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
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableCell
        
        
        cell.friendListButton.title = friends[indexPath.row].fullName
        return cell
    }
        

    
}

