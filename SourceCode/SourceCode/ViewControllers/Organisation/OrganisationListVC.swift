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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "CustomOrgListSingleCell", bundle: nil), forCellReuseIdentifier: "CustomOrgListSingleCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUI()
    }
    
    func setUI(){
        loginModel = UserDefaults.standard.value(forKey: loginResponseLocal) as! [String : Any]
        tblView.reloadData()
    }
    
    // MARK :- Button action
    @IBAction func btnAddOrgClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddOrganisationVC") as! AddOrganisationVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnLogoutClicked(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: loginResponseLocal)
        UserDefaults.standard.set(nil, forKey: loginTokenLocal)
        var controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")


        let mySceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        let navigationController = UINavigationController(rootViewController: controller!)
        navigationController.navigationBar.isHidden = true
        mySceneDelegate.window?.rootViewController = navigationController
        mySceneDelegate.window?.makeKeyAndVisible()
    }
    
}

extension OrganisationListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (loginModel?["orgs"] as? [String : Any])?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CustomOrgListSingleCell", for: indexPath) as! CustomOrgListSingleCell
        customCell.lblType.setCornerRadius(radius: 15.0)
        
        if let orgDict = (loginModel?["orgs"] as? [String : Any]) {
            let allKeys = Array(orgDict.keys)
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
