//
//  BoardTableViewCell.swift
//  Test
//
//  Created by 현수 on 10/29/23.
//

import UIKit

class BoardTableViewCell: UITableViewCell {

    static let Cell_Identifier : String = "BoardTableViewCell"
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var mLBTitle:UILabel!
    @IBOutlet weak var mLBRegDate:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
