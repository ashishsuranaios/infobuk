//
//  SelectionImglblTableViewCell.swift
//  SourceCode
//
//  Created by Apple on 01/01/22.
//

import UIKit

class SelectionImglblTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgSelection : UIImageView!
    @IBOutlet weak var cnstrntLeading : NSLayoutConstraint!
    @IBOutlet weak var btnTagSelection : CustomButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
