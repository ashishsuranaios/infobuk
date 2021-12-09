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
        insets.top = 10
        tblView.contentInset = insets
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setUI()
    }
    
    
    func setUI(){
        loginModel = UserDefaults.standard.value(forKey: loginResponseLocal) as! [String : Any]
        allKeys = UserDefaults.standard.value(forKey: UD_OrgDictKeysArrayLocal) as! [String]
        allKeys = allKeys.sorted(by: <)
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
        return (loginModel?["orgs"] as? [String : Any])?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CustomOrgListSingleCell", for: indexPath) as! CustomOrgListSingleCell
        customCell.lblType.setCornerRadius(radius: 11.0)
        
        if let orgDict = (loginModel?["orgs"] as? [String : Any]) {
            if let keyValue = allKeys[indexPath.row] as? String {
                if let orgRecord = orgDict[keyValue] as? [String : Any] {
                    customCell.orgDict = orgRecord
                    customCell.reloadData()
                }
                
            }
        }
        return customCell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    
    
    
}
