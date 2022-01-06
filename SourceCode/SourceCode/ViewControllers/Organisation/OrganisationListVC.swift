//
//  OrganisationListVC.swift
//  SourceCode
//
//  Created by Ashish on 02/12/21.
//

import UIKit

class OrganisationListVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!


    var loginModel : [String : Any]?
    var allKeys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "CustomOrgListSingleCell", bundle: nil), forCellReuseIdentifier: "CustomOrgListSingleCell")
        
        var insets: UIEdgeInsets = tblView.contentInset
        insets.bottom = 70
        tblView.contentInset = insets
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setUI()
    }
    
    
    func setUI(){
        loginModel = UserDefaults.standard.value(forKey: loginResponseLocal) as! [String : Any]
        allKeys = UserDefaults.standard.value(forKey: UD_OrgDictKeysArrayLocal) as! [String]
//        if var orgDict = (loginModel?["orgs"] as? [String : String]) {
//            let sortedOne = orgDict.sorted { (first, second) -> Bool in
//                return first.value > second.value
//            }
//            orgDict = orgDict.sorted { (lhs, rhs) -> Bool in
//
//              return ((lhs as! [String : Any])["orgId"] as! String == (rhs as! [String : Any])["orgId"] as! String)
////                return (lhs as! [String : Any])["orgId"]! < (rhs as! [String : Any])["orgId"]!
////              } else {
////                return lhs.value["Page"]! < rhs.value["Page"]!
////              }
//            }
            
//        }
        allKeys = allKeys.sorted {$0.localizedStandardCompare($1) == .orderedAscending}
        print(allKeys)
        print(loginModel)
//        if let orgDict = (loginModel?["orgs"] as? [String : Any]) {
//            allKeys = Array(orgDict.keys)
//        }
        tblView.reloadData()
        tblView.reloadData()

    }
    
    // MARK :- Button action
    @IBAction func btnAddOrgClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddOrganisationVC") as! AddOrganisationVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
//    @objc @IBAction func btnUserClicked(_ sender: Any) {
//        if let orgDict = (loginModel?["orgs"] as? [String : Any]) {
//            if let keyValue = allKeys[indexPath.section] as? String {
//                if let orgRecord = orgDict[keyValue] as? [String : Any] {
//                    customCell.orgDict = orgRecord
//                    customCell.reloadData(index: indexPath.row)
//                }
//                
//            }
//        }
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserDashboardVC") as! UserDashboardVC
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
    
    @IBAction func btnLogoutClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to logout from this account?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
                                        
            UserDefaults.standard.set(nil, forKey: loginResponseLocal)
            UserDefaults.standard.set(nil, forKey: loginTokenLocal)
            var controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")


            let mySceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            let navigationController = UINavigationController(rootViewController: controller!)
            navigationController.navigationBar.isHidden = true
            mySceneDelegate.window?.rootViewController = navigationController
            mySceneDelegate.window?.makeKeyAndVisible()
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true) {
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension OrganisationListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let orgDict = (loginModel?["orgs"] as? [String : Any]) {
            if let keyValue = allKeys[section] as? String {
                if let orgRecord = orgDict[keyValue] as? [String : Any] {
                    if let usersDict = orgRecord["users"] as? [String : Any] {
                        return usersDict.count
                    }
                }
                
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (loginModel?["orgs"] as? [String : Any])?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        let seperatorLineView = UIView.init(frame: CGRect.init(x: 15, y: 0, width: tableView.frame.width-30, height: 0.5))
        seperatorLineView.backgroundColor = .lightGray
    
        if let orgDict = (loginModel?["orgs"] as? [String : Any]) {
            if let keyValue = allKeys[section] as? String {
                if let orgRecord = orgDict[keyValue] as? [String : Any] {
                    let label = UILabel()
                    label.frame = CGRect.init(x: 15, y: 10, width: headerView.frame.width-30, height: headerView.frame.height-10)
                    label.text = (orgRecord["orgName"] ?? "") as? String
                    label.font = UIFont(name: "OpenSans-Regular", size: 17.0)
                    label.textColor = .black
                    
                    headerView.addSubview(label)
                }
            }
        }
        if section > 0 {
            headerView.addSubview(seperatorLineView)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CustomOrgListSingleCell", for: indexPath) as! CustomOrgListSingleCell
        customCell.lblType.setCornerRadius(radius: 9.0)
        
        if let orgDict = (loginModel?["orgs"] as? [String : Any]) {
            if let keyValue = allKeys[indexPath.section] as? String {
                if let orgRecord = orgDict[keyValue] as? [String : Any] {
                    customCell.orgDict = orgRecord
                    customCell.reloadData(index: indexPath.row)
                }
                
            }
        }
        customCell.parentVC = self
        customCell.btnUserClick.tag = indexPath.row
//        customCell.btnUserClick.addTarget(self, action: #selector(btnUserClicked(_:)), for: .touchUpInside)
        return customCell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
}
