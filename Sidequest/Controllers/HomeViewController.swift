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
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        
        if let currentUser = apiService.login(phoneNumber: "111") {
            AppState.shared.currentUser = currentUser
        } else {
            fatalError("User not found.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Populate Quests
        reloadQuests()
        
        // Populate Friends
        updateFriends()
    }
    
    func reloadQuests() {
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
        friendsTableView.reloadData()
    }
    
    func updateFriends() {
       guard let currentUser = AppState.shared.currentUser else { return }
        friends = apiService.getFriends(friendIds: currentUser.friendIds)
        friendsTableView.reloadData()
    }
    
    private func getSharedQuests(friend: User) -> [Quest] {
        guard let currentUser = AppState.shared.currentUser else { return [] }
                
        var sharedQuest: [Quest] = []
        for quest in quests {
            if quest.authorId == friend.id ||
                quest.assigned.contains(currentUser.id) ||
                quest.assigned.contains(friend.id) {
                sharedQuest.append(quest)
            }
        }
        return sharedQuest
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
    
    @IBAction func onFriendPressed(_ sender: ListButtonView) {
        // Work out which friend was pressed. Note: We're not using a tableView delegate here because the button is consuming the input before the table can get it.
        let buttonPosition = sender.convert(CGPoint.zero, to: friendsTableView)
        let index = friendsTableView.indexPathForRow(at: buttonPosition)
        guard let index = index else { return }
        
        let questsViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestsViewController") as! QuestsViewController
        
        let friend = friends[index.row]
        questsViewController.quests = getSharedQuests(friend: friend)
        questsViewController.heading = friend.fullName
        
        navigationController?.pushViewController(questsViewController, animated: true)
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableCell
        
        let friend = friends[indexPath.row]
        cell.friendListButton.title = friend.fullName
        cell.friendListButton.amount = getSharedQuests(friend: friend).count
        
        return cell
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newQuestViewController = segue.destination as? NewQuestViewController {
            newQuestViewController.onQuestAddedDelegate = reloadQuests
        }
        
        if let addFriendViewController = segue.destination as? AddFriendViewController {
            addFriendViewController.onAddDelegate = updateFriends
        }
    }
}

