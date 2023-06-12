//
//  FriendRequestViewController.swift
//  Sidequest
//
//  Created by Peter de Vroom on 10/6/2023.
//

import UIKit

class FriendRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendRequestTable: UITableView!
    var apiService: APIService!
    var friendRequests: [FriendRequest] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the APIService
        apiService = (UIApplication.shared.delegate as? AppDelegate)?.apiService
        
        guard let currentUser = AppState.shared.currentUser else { return }
        Task.init() {
            let friendRequestsResponse = await apiService.getFriendRequests()
            for request in friendRequestsResponse {
                if UUID(uuidString: request.recipient.id)! == currentUser.id {
                    friendRequests.append(request)
                }
            }
            friendRequestTable.reloadData()
        }
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendRequests.count
    }
    
    // Create Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as! FriendRequestTableCell
        
        let fr = friendRequests[indexPath.row]
        
        cell.nameLabel.text = fr.sender.fullName
        cell.friendRequest = fr
        
        return cell
    }

    @IBAction func onDeclinePressed(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: friendRequestTable)
        let index = friendRequestTable.indexPathForRow(at: buttonPosition)
        guard let index = index else { return }
        
        let request = friendRequests[index.row]
        Task.init() {
            await apiService.declineFriendRequest(friendId: UUID(uuidString: request.sender.id)!)
            friendRequests.remove(at: index.row)
            friendRequestTable.reloadData()
        }
    }
    
    @IBAction func onAcceptPressed(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: friendRequestTable)
        let index = friendRequestTable.indexPathForRow(at: buttonPosition)
        guard let index = index else { return }
        
        let request = friendRequests[index.row]
        Task.init() {
            await apiService.acceptFriendRequest(friendId: UUID(uuidString: request.sender.id)!)
            friendRequests.remove(at: index.row)
            friendRequestTable.reloadData()
        }
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
