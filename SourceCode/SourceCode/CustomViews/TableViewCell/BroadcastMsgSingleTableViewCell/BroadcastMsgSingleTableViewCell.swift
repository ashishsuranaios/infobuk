//
//  BroadcastMsgSingleTableViewCell.swift
//  SourceCode
//
//  Created by Apple on 01/01/22.
//

import UIKit

class BroadcastMsgSingleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainStackViewBg: UIStackView!

    @IBOutlet weak var lblMsg: UILabel!

    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var btnExpandCollapse: CustomButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var cnstrntBtnExpandHeight: NSLayoutConstraint!

    var parentVC : MainViewController?
    var index = 0
    var record : Fields?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainStackViewBg.layer.borderWidth = 0.5
        mainStackViewBg.layer.borderColor = UIColor.lightGray.cgColor
        mainStackViewBg.layer.cornerRadius = 8.0
        mainStackViewBg.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
