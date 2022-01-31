//
//  OrgSettingVC.swift
//  SourceCode
//
//  Created by Apple on 29/01/22.
//

import UIKit
import JWTDecode

class OrgSettingVC: MainViewController {
    @IBOutlet weak var shadowBg: UIView!
    
    @IBOutlet weak var btnMuteUnmute: UIButton!
    @IBOutlet weak var btnBlockActivate: UIButton!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!

    var isShadowApplied = false
    
    var strBlockedAction = "You have Blocked this Organisation. \nYou can not view/manage this organisation."
    var strMutedAction = "You have Muted this Organisation. \nYou are currently associated with this organisation. \nYou have also muted this organisation so you will not get any notification from them."
    var strAccepted = "You have Accepted this Organisation. \nYou are currently associated with this organisation."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBlockActivate.setCornerRadius(radius: 8.0)
        btnMuteUnmute.setCornerRadius(radius: 8.0)
        btnBlockActivate.viewBorder(borderColor: AppColor, borderWidth: 1.0)
        btnMuteUnmute.viewBorder(borderColor: UIColor.systemPink, borderWidth: 1.0)
        btnMuteUnmute.setTitleColor(UIColor.systemPink, for: .normal)
        
        btnBlockActivate.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 16)
        btnMuteUnmute.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 16)

        
        lblTitle.text = (APP_DEL.userSelectedDict["orgName"] ?? "")
        let myAttribute = [ NSAttributedString.Key.font:  UIFont(name: "OpenSans-SemiBold", size: 15), NSAttributedString.Key.foregroundColor : UIColor.darkGray]

        let action = (APP_DEL.userSelectedDict["orgStatus"] ?? "")
        if action == "blocked" {
            self.btnBlockActivate.setTitle("    Active    ", for: .normal)
            self.btnBlockActivate.backgroundColor = AppColor
            self.btnBlockActivate.setTitleColor(UIColor.white, for: .normal)
            self.btnBlockActivate.viewBorder(borderColor: AppColor, borderWidth: 1.0)
            
            self.btnMuteUnmute.isHidden = true
            let strDesc = NSMutableAttributedString(string: strBlockedAction, attributes: myAttribute as [NSAttributedString.Key : Any])
            let range = ("\(strBlockedAction)" as NSString).range(of: "Blocked")
            strDesc.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
            self.lblDesc.attributedText = strDesc
            
        } else if action == "muted" {
            self.btnBlockActivate.setTitle("    Block    ", for: .normal)
            self.btnBlockActivate.backgroundColor = UIColor.white
            self.btnBlockActivate.setTitleColor(UIColor.systemPink, for: .normal)
            self.btnBlockActivate.viewBorder(borderColor: UIColor.systemPink, borderWidth: 1.0)

            self.btnMuteUnmute.setTitle("UnMute Notification", for: .normal)
            self.btnMuteUnmute.setTitleColor(AppColor, for: .normal)
            self.btnMuteUnmute.viewBorder(borderColor: AppColor, borderWidth: 1.0)
            
            let strDesc = NSMutableAttributedString(string: strMutedAction, attributes: myAttribute as [NSAttributedString.Key : Any])
            let range = ("\(strMutedAction)" as NSString).range(of: "Muted")
            strDesc.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
            self.lblDesc.attributedText = strDesc
        } else { //accept
            self.btnBlockActivate.setTitle("    Block    ", for: .normal)
            self.btnBlockActivate.backgroundColor = UIColor.white
            self.btnBlockActivate.setTitleColor(UIColor.systemPink, for: .normal)
            self.btnBlockActivate.viewBorder(borderColor: UIColor.systemPink, borderWidth: 1.0)
            
            self.btnMuteUnmute.setTitle("Mute", for: .normal)
            self.btnMuteUnmute.setTitleColor(.systemPink, for: .normal)
            self.btnMuteUnmute.viewBorder(borderColor: .systemPink, borderWidth: 1.0)
            
            let strDesc = NSMutableAttributedString(string: strAccepted, attributes: myAttribute as [NSAttributedString.Key : Any])
            let range = ("\(strAccepted)" as NSString).range(of: "Accepted")
            strDesc.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColor, range: range)
            self.lblDesc.attributedText = strDesc

        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (!isShadowApplied){
            isShadowApplied = true
            shadowBg.isHidden = false
//            shadowBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
            shadowBg.setCornerRadius(radius: 8.0)
            shadowBg.viewBorder(borderColor: .lightGray, borderWidth: 1.0)

        }
    }
    
    // MARK :- BUtton Action
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnActivateBlockClicked(_ sender: UIButton) {
        var strTitleBtn = sender.title(for: .normal)
        strTitleBtn = strTitleBtn?.replacingOccurrences(of: " ", with: "")
        if strTitleBtn!.uppercased() == "BLOCK" {
            self.updateOrganisation(action: "block")
        } else {
            self.updateOrganisation(action: "accept")

        }
    }
    
    @IBAction func btnMuteUnmuteClicked(_ sender: UIButton) {
        var strTitleBtn = sender.title(for: .normal)
        strTitleBtn = strTitleBtn?.replacingOccurrences(of: " ", with: "")
        if strTitleBtn!.uppercased() == "MUTE" {
            self.updateOrganisation(action: "mute")
        } else {
            self.updateOrganisation(action: "unmute")
        }
    }
    
    func updateOrganisation(action : String) {
        self.startLoading()
        let param : [String : String] = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")", "action" : action]
        APICallManager.instance.requestForOrganisationStatusChanged(param: param) { (res) in
            if res.success ?? false {
                let jwt = try? decode(jwt: res.token ?? "")

                UserDefaults.standard.set(jwt?.body, forKey: loginResponseLocal)
                UserDefaults.standard.set(res.token, forKey: loginTokenLocal)
                
                var allKeys = [String]()

                if let orgDict = (jwt?.body["orgs"] as? [String : Any]) {
                    allKeys = Array(orgDict.keys)
                }
                UserDefaults.standard.set(allKeys, forKey: UD_OrgDictKeysArrayLocal)
                
                let myAttribute = [ NSAttributedString.Key.font:  UIFont(name: "OpenSans-Regular", size: 15)]

                if action == "mute" {
                    self.btnMuteUnmute.setTitle("UnMute Notification", for: .normal)
                    self.btnMuteUnmute.setTitleColor(AppColor, for: .normal)
                    self.btnMuteUnmute.viewBorder(borderColor: AppColor, borderWidth: 1.0)
                    
                    let strDesc = NSMutableAttributedString(string: self.strMutedAction, attributes: myAttribute as [NSAttributedString.Key : Any])
                    let range = ("\(self.strMutedAction)" as NSString).range(of: "Muted")
                    strDesc.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
                    self.lblDesc.attributedText = strDesc
                }
//                else if action == "unmute" {
//                    self.btnMuteUnmute.setTitle("  Mute  ", for: .normal)
//                }
                else if action == "block" {
                    self.btnBlockActivate.setTitle("    Active    ", for: .normal)
                    self.btnBlockActivate.backgroundColor = AppColor
                    self.btnBlockActivate.setTitleColor(UIColor.white, for: .normal)
                    self.btnBlockActivate.viewBorder(borderColor: AppColor, borderWidth: 1.0)
                    
                    self.btnMuteUnmute.isHidden = true
                    
                    let strDesc = NSMutableAttributedString(string: self.strBlockedAction, attributes: myAttribute as [NSAttributedString.Key : Any])
                    let range = ("\(self.strBlockedAction)" as NSString).range(of: "Blocked")
                    strDesc.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
                    self.lblDesc.attributedText = strDesc
                } else { //accept
                    self.btnMuteUnmute.setTitle("Mute", for: .normal)
                    self.btnMuteUnmute.setTitleColor(.systemPink, for: .normal)
                    self.btnMuteUnmute.viewBorder(borderColor: .systemPink, borderWidth: 1.0)
                    
                    self.btnBlockActivate.setTitle("    Block    ", for: .normal)
                    self.btnBlockActivate.backgroundColor = UIColor.white
                    self.btnBlockActivate.setTitleColor(UIColor.systemPink, for: .normal)
                    self.btnBlockActivate.viewBorder(borderColor: UIColor.systemPink, borderWidth: 1.0)
                    self.btnMuteUnmute.isHidden = false
                    
                    let strDesc = NSMutableAttributedString(string: self.strAccepted, attributes: myAttribute as [NSAttributedString.Key : Any])
                    let range = ("\(self.strAccepted)" as NSString).range(of: "Accepted")
                    strDesc.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColor, range: range)
                    self.lblDesc.attributedText = strDesc
                }
                
                //self.showAlertWithBackAction(msg: "Organization registered successfully.")
            } else {
            }
            self.stopLoading()
        } onFailure: { (err) in
            self.stopLoading()

        }
    }

}
