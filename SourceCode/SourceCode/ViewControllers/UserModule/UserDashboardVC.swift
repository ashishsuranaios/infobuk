//
//  UserDashboardVC.swift
//  SourceCode
//
//  Created by Apple on 25/12/21.
//

import UIKit

class UserDashboardVC: UIViewController {

    @IBOutlet weak var shadowTagsBg: UIView!
    @IBOutlet weak var shadowPermissionBg: UIView!
    @IBOutlet weak var shadowCustomFieldsBg: UIView!
    @IBOutlet weak var shadowUsersBg: UIView!
    @IBOutlet weak var shadowBroadcastsBg: UIView!
    @IBOutlet weak var shadowRecordsBg: UIView!

    
    var isShadowApplied = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        self.view.layoutIfNeeded()

        if (!isShadowApplied){
            isShadowApplied = true
            shadowTagsBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
            shadowPermissionBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
            shadowCustomFieldsBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
            shadowUsersBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
            shadowBroadcastsBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)
            shadowRecordsBg.setShodowEffectWithCornerRadius(radius: shodowBgViewCornerRadius)

        }
        
    }
    
    // MARK :- BUtton Action
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTaglistClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TagsListVC") as! TagsListVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnPermissionClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PermissionVC") as! PermissionVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnCustomFieldsClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TagsListVC") as! TagsListVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnUsersClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TagsListVC") as! TagsListVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnBroadCastClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TagsListVC") as! TagsListVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnAppNameClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TagsListVC") as! TagsListVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

}
