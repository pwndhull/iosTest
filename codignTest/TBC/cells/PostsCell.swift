//
//  PostsCell.swift
//  codignTest
//
//  Created by Pawan Dhull on 24/02/21.
//

import UIKit

class PostsCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var userId: UILabel!
    
    @IBOutlet weak var Id: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
