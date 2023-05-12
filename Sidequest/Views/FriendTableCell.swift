//
//  FriendTableCellTableViewCell.swift
//  Sidequest
//
//  Created by Liam McEvoy on 12/5/2023.
//

import UIKit

class FriendTableCell: UITableViewCell {

    
    @IBOutlet weak var friendListButton: ListButtonView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
