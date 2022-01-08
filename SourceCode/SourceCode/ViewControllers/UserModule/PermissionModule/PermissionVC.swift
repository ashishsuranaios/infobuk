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

    var permissionModel : PermissionsModel?
    var tagsModel : TagsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getTagsList()
    }
    
    func getTagsList() {
        self.startLoading()
        let param : [String : String] = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "view"]
        APICallManager.instance.requestForTagListView(param: param) { (res) in
            if res.success ?? false {
                self.tagsModel = res
                self.getPermissionList()
            } else {
                self.stopLoading()
            }
        } onFailure: { (err) in
            self.stopLoading()

        }
    }
    
    func getPermissionList() {
        self.startLoading()
        let param : [String : String] = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "view"]
        APICallManager.instance.requestForPermissionList(param: param) { (res) in
            if res.success ?? false {
                self.permissionModel = res
                self.tblView.reloadData()
            } else {
            }
            self.stopLoading()
        } onFailure: { (err) in
            self.stopLoading()
        }
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
    
    @IBAction func btnAddClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddPermissionVC") as! AddPermissionVC
        controller.strTitleName = "Add Permission"
        controller.type = 0
        controller.categoriesArray = tagsModel?.categoriesAndValues ?? [CategoriesAndValues]()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc @IBAction func btnExpandClicked(_ sender: UIButton) {
        if expandIndexList.contains(sender.tag){
            expandIndexList.remove(at: expandIndexList.firstIndex(of: sender.tag)!)
        } else {
            expandIndexList.append(sender.tag)
        }
//        let boolValue =  !(tagsModel?.categoriesAndValues?[sender.tag].isSelected ?? true)
//        tagsModel?.categoriesAndValues?[sender.tag].isSelected = boolValue
        self.tblView.reloadData()
    }
    
    @objc @IBAction func btnEditClicked(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddPermissionVC") as! AddPermissionVC
        controller.strTitleName = "Edit Permission"
        controller.type = 1
        controller.recordEdit = permissionModel?.permissions?[sender.tag]
        controller.categoriesArray = tagsModel?.categoriesAndValues ?? [CategoriesAndValues]()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc @IBAction func btnDeleteClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Infobuk", message: "Are you sure you want to delete custom permission?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            self.deleteTagGroup(index: sender.tag)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func deleteTagGroup (index : Int) {
        self.startLoading()

        let catId =   permissionModel?.permissions?[index].id ?? ""

        let param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "delete", "permissionId" : catId]

        APICallManager.instance.requestForPermissionList(param: param) { (res) in
            if res.success ?? false {
                let alert = UIAlertController(title: "Infobuk", message: "Success", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    self.expandIndexList.removeAll()
                    self.viewWillAppear(true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.showAlert(msg: res.error ?? "Something went wrong. Please try again.")
            }
            self.stopLoading()
        } onFailure: { (err) in
            self.stopLoading()
            self.showAlert(msg: err)

        }
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
        let rowCount = permissionModel?.permissions?.count ?? 0
        if rowCount <= 0 &&  permissionModel != nil {
            tblView.setEmptyMessage("No permission found")
        } else {
            tblView.restore()
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CustomSinglePermissionTableViewCell", for: indexPath) as! CustomSinglePermissionTableViewCell
        let recPermission = permissionModel?.permissions?[indexPath.row]
        
        
        
        customCell.lblName.text = recPermission?.name ?? ""
        customCell.record = recPermission!
        customCell.parentVC = self
        customCell.btnExpandCollapse.tag = indexPath.row
        customCell.btnEdit.tag = indexPath.row
        customCell.btnDelete.tag = indexPath.row
        customCell.btnExpandCollapse.addTarget(self, action: #selector(btnExpandClicked(_:)), for: .touchUpInside)
        customCell.btnEdit.addTarget(self, action: #selector(btnEditClicked(_:)), for: .touchUpInside)
        customCell.btnDelete.addTarget(self, action: #selector(btnDeleteClicked(_:)), for: .touchUpInside)
        customCell.tagsModel = self.tagsModel
        
        if expandIndexList.contains(indexPath.row) {
            customCell.bottomView.isHidden = false
            customCell.reloadBottomData()
        } else {
            customCell.bottomView.isHidden = true
        }

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
