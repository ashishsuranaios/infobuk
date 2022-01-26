//
//  CustomSingleTagTableViewCell.swift
//  SourceCode
//
//  Created by Apple on 25/12/21.
//

import UIKit

class CustomSingleTagTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainStackViewBg: UIStackView!

    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var cnstrntHeightTblView: NSLayoutConstraint!

    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnExpandCollapse: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!

    
    var tagsModel : TagsModel?

    var parentVC : MainViewController?
    var index = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "TagChildSingleTableViewCell", bundle: nil), forCellReuseIdentifier: "TagChildSingleTableViewCell")
        
        tblView.isScrollEnabled = false
        
        mainStackViewBg.layer.borderWidth = 0.5
        mainStackViewBg.layer.borderColor = UIColor.lightGray.cgColor
        mainStackViewBg.layer.cornerRadius = 8.0
        mainStackViewBg.layer.masksToBounds = true
        
        bottomView.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadBottomData() {
        tblView.reloadData()
    }
    
    @objc @IBAction func btnEditTagGroup(_ sender: UIButton) {
        let controller = parentVC?.storyboard?.instantiateViewController(withIdentifier: "AddTagsVC") as! AddTagsVC
        controller.strTitleName = "Edit tag"
        controller.type = 3
        controller.recordEdit =  tagsModel?.categoriesAndValues?[btnEdit.tag].values_?[sender.tag]
        controller.recordTagGroup = tagsModel?.categoriesAndValues?[btnEdit.tag]
        parentVC?.navigationController?.pushViewController(controller, animated: true)
    }
    

    
    @objc @IBAction func btnAddTagChild(_ sender: UIButton) {
        let controller = parentVC?.storyboard?.instantiateViewController(withIdentifier: "AddTagsVC") as! AddTagsVC
        controller.strTitleName = "Add tag"
        controller.type = 2
//        controller.recordEdit =  tagsModel?.categoriesAndValues?[btnEdit.tag].values_?[sender.tag]
        controller.recordTagGroup = tagsModel?.categoriesAndValues?[btnEdit.tag]
        parentVC?.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc @IBAction func btnDeleteTagGroup(_ sender: UIButton) {
        let alert = UIAlertController(title: "Infobuk", message: "Are you sure you want to delete this tag?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            self.deleteTag(index: sender.tag)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
        }))
        parentVC?.present(alert, animated: true, completion: nil)
        
    }
    
    func deleteTag (index : Int) {
        let catId =  (tagsModel?.categoriesAndValues?[btnEdit.tag].id ?? "")

        let param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "delete", "categoryId" : catId, "valueId" : tagsModel?.categoriesAndValues?[btnEdit.tag].values_?[index].id ?? ""]
        
        APICallManager.instance.requestForAddTagChild(param: param) { (res) in
            if res.success ?? false {
//                let alert = UIAlertController(title: "Infobuk", message: "Success", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    self.parentVC?.viewWillAppear(true)
//                }))
//                self.parentVC?.present(alert, animated: true, completion: nil)
            } else {
                self.parentVC?.showAlert(msg: res.error ?? "Something went wrong. Please try again.")

            }
            self.parentVC?.stopLoading()
        } onFailure: { (err) in
            self.parentVC?.stopLoading()
            self.parentVC?.showAlert(msg:err)

        }
    }
    
}

extension CustomSingleTagTableViewCell : UITableViewDelegate, UITableViewDataSource {
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
        let rowCount = tagsModel?.categoriesAndValues?[btnExpandCollapse.tag].values_?.count ?? 0
        cnstrntHeightTblView.constant = CGFloat(rowCount * 35)
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "TagChildSingleTableViewCell", for: indexPath) as! TagChildSingleTableViewCell
        customCell.btnEdit.tag = indexPath.row
        customCell.btnDelete.tag = indexPath.row
        customCell.btnDelete.addTarget(self, action: #selector(btnDeleteTagGroup(_:)), for: .touchUpInside)
        customCell.btnEdit.addTarget(self, action: #selector(btnEditTagGroup(_:)), for: .touchUpInside)
        customCell.lblTitle.text = tagsModel?.categoriesAndValues?[btnEdit.tag].values_?[indexPath.row].value ?? ""
        return customCell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
