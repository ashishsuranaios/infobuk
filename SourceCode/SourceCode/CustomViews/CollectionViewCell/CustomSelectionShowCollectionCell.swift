//
//  CustomSelectionShowCollectionCell.swift
//  SourceCode
//
//  Created by Apple on 30/12/21.
//

import UIKit

class CustomSelectionShowCollectionCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewBg: UIView!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBg.layer.cornerRadius = 17.0
        viewBg.layer.masksToBounds = true
    }

}
