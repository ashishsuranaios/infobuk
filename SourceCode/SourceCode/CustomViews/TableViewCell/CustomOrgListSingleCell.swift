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
//    @IBOutlet weak var lblOrgName : UILabel!
    @IBOutlet weak var lblType : UILabel!
    @IBOutlet weak var btnSetting : UIButton!
    @IBOutlet weak var lblStatus : UILabel!

    var orgDict : [String : Any]?
    var isShadowApplied = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let seconds = 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            if !self.isShadowApplied {
                self.isShadowApplied = true
            self.shadowView.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
            }
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadData() {
//        lblOrgName.text = (orgDict?["orgName"] ?? "") as? String

        if let usersDict = orgDict?["users"] as? [String : Any] {
            let allKeys = Array(usersDict.keys)
            if let keyValue = allKeys.first as? String {
                if let userRec = usersDict[keyValue] as? [String : Any] {
                    lblName.text = (userRec["fullName"] ?? "") as? String
                    lblType.text = " " + ((userRec["userType"] ?? "") as? String)!.capitalizingFirstLetter() + " "
                    
                    if let status = userRec["orgStatus"] as? String {
                        if status == "accepted" {
                            lblStatus.isHidden = true
                        } else if status == "blocked" {
                            lblStatus.isHidden = false
                            lblStatus.text = " " + status.capitalizingFirstLetter() + " "
                            lblStatus.viewBorder(borderColor: UIColor.red, borderWidth: 1.0)
                            lblStatus.setCornerRadius(radius: lblStatus.frame.size.height/2)
                            lblStatus.textColor = UIColor.red
                        }else {
                            lblStatus.isHidden = false
                            lblStatus.text = " " + status.capitalizingFirstLetter() + " "
                            lblStatus.viewBorder(borderColor: UIColor.orange, borderWidth: 1.0)
                            lblStatus.setCornerRadius(radius: lblStatus.frame.size.height/2)
                            lblStatus.textColor = UIColor.orange
                        }
                    }
                }
                
            }
        }
    }
    
    func checkForShadow()  {
        
    }
    
}
