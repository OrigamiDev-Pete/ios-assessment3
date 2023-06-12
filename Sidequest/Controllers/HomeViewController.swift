//
//  HomeViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 5/5/2023.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var apiService: APIService!
    
    var friends: [UserResponse] = []
    var quests: [Quest] = []
    @IBOutlet weak var allQuestsButton: ListButtonView!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var todayQuestsButton: ListButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkTokenIsValid()
        if (AppState.shared.token != nil) {
            // Populate Quests
            reloadQuests()
            
            // Populate Friends
            updateFriends()
        }
    }
    
    func reloadQuests() {
        Task.init() {
            let questResponses = await apiService.getQuests()
            
            quests = []
            for response in questResponses {
                quests.append(Quest(response: response))
            }
            
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
    }
    
    func updateFriends() {
        Task.init() {
            friends = await apiService.getFriends()
            friendsTableView.reloadData()
        }
    }
    
    private func getSharedQuests(friend: UserResponse) -> [Quest] {
        guard let currentUser = AppState.shared.currentUser else { return [] }
                
        var sharedQuest: [Quest] = []
        
        let friendId = UUID(uuidString: friend.id)!
        
        for quest in quests {
            if quest.authorId == friendId ||
                quest.assigned.contains(currentUser.id) ||
                quest.assigned.contains(friendId) {
                sharedQuest.append(quest)
            }
        }
        return sharedQuest
    }
    
    func checkTokenIsValid() {
        // Try to get the token from userDefaults
        let userDefaults = UserDefaults.standard
        //        userDefaults.removeObject(forKey: "token")
        if let token = userDefaults.string(forKey: "token") {
            AppState.shared.token = token
            Task.init() {
                let response = await apiService.getUser()
                if let response = response {
                    let user = User(response: response)
                    AppState.shared.currentUser = user
                }
                if AppState.shared.token == nil {
                    let signInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    signInViewController.navigationItem.setHidesBackButton(true, animated: false)
                    navigationController?.pushViewController(signInViewController, animated: false)
                }
            }
        }
        if AppState.shared.token == nil {
            let signInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            signInViewController.navigationItem.setHidesBackButton(true, animated: false)
            navigationController?.pushViewController(signInViewController, animated: false)
        }
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
        questsViewController.selectedFriend = User(response: friend)
        
        navigationController?.pushViewController(questsViewController, animated: true)
    }
    
    @IBAction func onLogoutPressed(_ sender: UIButton) {
        AppState.shared.currentUser = nil
        AppState.shared.token = nil
        let signInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        signInViewController.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.pushViewController(signInViewController, animated: false)
    }
    
    @IBAction func onRefreshPressed(_ sender: UIButton) {
        checkTokenIsValid()
        if (AppState.shared.token != nil) {
            // Populate Quests
            reloadQuests()
            // Populate Friends
            updateFriends()
        }
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
            newQuestViewController.onModalCompleteDelegate = reloadQuests
            newQuestViewController.onNewQuestDelegate = { (newQuest) -> Void in
                self.reloadQuests()
            }
        }
        
        if let addFriendViewController = segue.destination as? AddFriendViewController {
            addFriendViewController.onAddDelegate = updateFriends
        }
    }
}

