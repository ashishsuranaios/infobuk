//
//  TagChildSingleTableViewCell.swift
//  SourceCode
//
//  Created by Apple on 25/12/21.
//

import UIKit

class TagChildSingleTableViewCell: UITableViewCell {
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
