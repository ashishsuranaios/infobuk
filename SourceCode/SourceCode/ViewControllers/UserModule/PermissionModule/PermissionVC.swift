//
//  PermissionVC.swift
//  SourceCode
//
//  Created by Apple on 30/12/21.
//

import UIKit

class PermissionVC: MainViewController {
    @IBOutlet weak var tblView: UITableView!
    var expandIndexList = [Int]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }

    func setUI() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "CustomSinglePermissionTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomSinglePermissionTableViewCell")
        
        var insets: UIEdgeInsets = tblView.contentInset
        insets.bottom = 70
        tblView.contentInset = insets
        
        let deadlineTime = DispatchTime.now() + .milliseconds(300)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.tblView.reloadData()
        }
    }
    
    // MARK :- BUtton Action
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension PermissionVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let orgDict = (loginModel?["orgs"] as? [String : Any]) {
//            if let keyValue = allKeys[section] as? String {
//                if let orgRecord = orgDict[keyValue] as? [String : Any] {
//                    if let usersDict = orgRecord["users"] as? [String : Any] {
//                        return usersDict.count
//                    }
//                }
//
//            }
//        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CustomSinglePermissionTableViewCell", for: indexPath) as! CustomSinglePermissionTableViewCell
        
//        customCell.lblName.text = tagsModel?.categoriesAndValues?[indexPath.row].name ?? ""
//        customCell.tagsModel = tagsModel
//        customCell.parentVC = self
//        customCell.btnExpandCollapse.tag = indexPath.row
//        customCell.btnEdit.tag = indexPath.row
//        customCell.btnDelete.tag = indexPath.row
//        customCell.btnExpandCollapse.addTarget(self, action: #selector(btnExpandClicked(_:)), for: .touchUpInside)
//        customCell.btnEdit.addTarget(self, action: #selector(btnEditTagGroup(_:)), for: .touchUpInside)
//        customCell.btnDelete.addTarget(self, action: #selector(btnDeleteTagGroup(_:)), for: .touchUpInside)
//
//        if expandIndexList.contains(indexPath.row) {
//            customCell.bottomView.isHidden = false
            customCell.reloadBottomData()
//        } else {
//            customCell.bottomView.isHidden = true
//        }

        return customCell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let customCell = tableView.cellForRow(at: indexPath) as? CustomSinglePermissionTableViewCell {
            customCell.reloadBottomData()
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
}
