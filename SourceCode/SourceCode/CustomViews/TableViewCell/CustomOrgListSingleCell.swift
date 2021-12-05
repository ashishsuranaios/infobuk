//
//  CustomOrgListSingleCell.swift
//  SourceCode
//
//  Created by Apple on 05/12/21.
//

import UIKit

class CustomOrgListSingleCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblOrgName : UILabel!
    @IBOutlet weak var lblType : UILabel!
    @IBOutlet weak var btnSetting : UIButton!

    var orgDict : [String : Any]?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.shadowView.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadData()  {
        lblOrgName.text = (orgDict?["orgName"] ?? "") as? String
        if let usersDict = orgDict?["users"] as? [String : Any] {
            let allKeys = Array(usersDict.keys)
            if let keyValue = allKeys.first as? String {
                if let userRec = usersDict[keyValue] as? [String : Any] {
                    lblName.text = (userRec["fullName"] ?? "") as? String
                }
                
            }
        }
    }
    
}
