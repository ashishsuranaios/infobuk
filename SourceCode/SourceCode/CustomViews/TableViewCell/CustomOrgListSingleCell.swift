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
    
    @IBOutlet weak var btnUserClick : UIButton!


    var orgDict : [String : Any]?
    var isShadowApplied = false
    var parentVC : UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let seconds = 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
//            if !self.isShadowApplied {
//                self.isShadowApplied = true
//            self.shadowView.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
//            }
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadData(index : Int) {
//        lblOrgName.text = (orgDict?["orgName"] ?? "") as? String

        if let usersDict = orgDict?["users"] as? [String : Any] {
            var allKeys = Array(usersDict.keys)
            allKeys = allKeys.sorted {$0.localizedStandardCompare($1) == .orderedAscending}

            if let keyValue = allKeys[index] as? String {
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
    
    @objc @IBAction func btnUserClicked(_ sender: UIButton) {
        
        if let usersDict = orgDict?["users"] as? [String : Any] {
            var allKeys = Array(usersDict.keys)
            allKeys = allKeys.sorted {$0.localizedStandardCompare($1) == .orderedAscending}

            if let keyValue = allKeys[sender.tag] as? String {
                if let userRec = usersDict[keyValue] as? [String : Any] {
                    
                    APP_DEL.userSelectedDict = userRec as! [String : String]
                    
                    let controller = parentVC?.storyboard?.instantiateViewController(withIdentifier: "UserDashboardVC") as! UserDashboardVC
                    parentVC?.navigationController?.pushViewController(controller, animated: true)
                }
                
            }
        }
        
        
    }
    
}
