//
//  TagsListVC.swift
//  SourceCode
//
//  Created by Apple on 25/12/21.
//

import UIKit
import JWTDecode

class TagsListVC: MainViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var tagsModel : TagsModel?
    var expandIndexList = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "CustomSingleTagTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomSingleTagTableViewCell")
        
        var insets: UIEdgeInsets = tblView.contentInset
        insets.bottom = 70
        tblView.contentInset = insets
        
        print("User Dict ==> \(APP_DEL.userSelectedDict)")
        //User Dict ==> ["orgStatus": "accepted", "userId": "124", "orgId": "59", "fullName": "Ashish  Kumar", "userType": "admin"]
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
                self.tblView.reloadData()
            } else {
            }
            self.stopLoading()
        } onFailure: { (err) in
            self.stopLoading()

        }
    }
    
    
    // MARK :- Button action
    @IBAction func btnAddClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddTagsVC") as! AddTagsVC
        controller.strTitleName = "Add tag group"
        controller.type = 0
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
    
    @objc @IBAction func btnEditTagGroup(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddTagsVC") as! AddTagsVC
        controller.strTitleName = "Edit tag group"
        controller.type = 1
        controller.recordTagGroup =  tagsModel?.categoriesAndValues?[sender.tag]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc @IBAction func btnDeleteTagGroup(_ sender: UIButton) {
        let alert = UIAlertController(title: "Infobuk", message: "Are you sure you want to delete this tag group?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            self.deleteTagGroup(index: sender.tag)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func deleteTagGroup (index : Int) {
        self.startLoading()
        let catId =  (tagsModel?.categoriesAndValues?[index].id ?? "")

        let param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "delete", "categoryId" : catId]
        
        APICallManager.instance.requestForAddTagGroup(param: param) { (res) in
            if res.success ?? false {
//                let alert = UIAlertController(title: "Infobuk", message: "Success", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    self.expandIndexList.removeAll()
                    self.viewWillAppear(true)
//                }))
//                self.present(alert, animated: true, completion: nil)
            } else {
                self.showAlert(msg: res.error ?? "Something went wrong. Please try again.")
            }
            self.stopLoading()
        } onFailure: { (err) in
            self.showAlert(msg: err)
            self.stopLoading()

        }
    }
    
    

}

extension TagsListVC : UITableViewDelegate, UITableViewDataSource {
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
        let rowCount = tagsModel?.categoriesAndValues?.count ?? 0
        if rowCount <= 0  &&  tagsModel != nil {
            tblView.setEmptyMessage("No tags and tag group found")
        } else {
            tblView.restore()
        }
        
        if tagsModel != nil {
            let newArray = tagsModel!.categoriesAndValues!.sorted(by: { Int($0.id!)! < Int($1.id!)! })
            tagsModel!.categoriesAndValues = newArray
        }
        
        if tagsModel != nil {
            var i = 0
            for _ in tagsModel!.categoriesAndValues! {
                let newArray = (tagsModel?.categoriesAndValues?[i])?.valuesSorted?.sorted(by: { Int($0.id!)! < Int($1.id!)! })
                (tagsModel!.categoriesAndValues![i]).valuesSorted = newArray
                i = i + 1
            }
        }
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CustomSingleTagTableViewCell", for: indexPath) as! CustomSingleTagTableViewCell
        
        customCell.lblName.text = tagsModel?.categoriesAndValues?[indexPath.row].name ?? ""
        customCell.tagsModel = tagsModel
        customCell.parentVC = self
        customCell.btnExpandCollapse.tag = indexPath.row
        customCell.btnEdit.tag = indexPath.row
        customCell.btnDelete.tag = indexPath.row
        customCell.btnExpandCollapse.addTarget(self, action: #selector(btnExpandClicked(_:)), for: .touchUpInside)
        customCell.btnEdit.addTarget(self, action: #selector(btnEditTagGroup(_:)), for: .touchUpInside)
        customCell.btnDelete.addTarget(self, action: #selector(btnDeleteTagGroup(_:)), for: .touchUpInside)

        if expandIndexList.contains(indexPath.row) {
            customCell.bottomView.isHidden = false
            customCell.reloadBottomData()
        } else {
            customCell.bottomView.isHidden = true
        }

        return customCell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
}


