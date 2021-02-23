//
//  PhotosCardTableViewCell.swift
//  codignTest
//
//  Created by Pawan Dhull on 23/02/21.
//

import UIKit

class PhotosCardTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var albumId: UILabel!
    
    @IBOutlet weak var Id: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
