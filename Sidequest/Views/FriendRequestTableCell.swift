//
//  FriendRequestTableCell.swift
//  Sidequest
//
//  Created by Peter de Vroom on 10/6/2023.
//

import UIKit

class FriendRequestTableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    weak var friendRequest: FriendRequest!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
