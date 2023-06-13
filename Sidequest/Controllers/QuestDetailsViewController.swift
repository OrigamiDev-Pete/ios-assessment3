//
//  QuestDetailsViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 6/5/2023.
//

import UIKit

class QuestDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var onFriendSelectDelegate: ((User) -> Void)? = nil
    
    var apiService: APIService!
    var friends: [UserResponse] = []
    
    @IBOutlet weak var friendTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        
        Task.init() {
            friends = await apiService.getFriends()
            friendTable.reloadData()
        }
    }
    
    // MARK: Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendNameCell", for: indexPath)
        
        var contentConfiguration = UIListContentConfiguration.cell()
        contentConfiguration.text = friends[indexPath.row].fullName
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onFriendSelectDelegate = onFriendSelectDelegate {
            onFriendSelectDelegate(User(response: friends[indexPath.row]))
        }
        dismiss(animated: true)
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
