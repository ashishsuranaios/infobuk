//
//  CustomOnlyLabelCell.swift
//  SourceCode
//
//  Created by Ashish on 07/12/21.
//

import UIKit

class CustomOnlyLabelCell: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
