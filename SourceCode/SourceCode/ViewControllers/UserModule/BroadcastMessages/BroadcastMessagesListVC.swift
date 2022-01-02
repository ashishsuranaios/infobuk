//
//  BroadcastMessagesListVC.swift
//  SourceCode
//
//  Created by Apple on 01/01/22.
//

import UIKit

class BroadcastMessagesListVC: MainViewController {


    @IBOutlet weak var tblView: UITableView!
    var expandIndexList = [Int]()

    var broadcastMsgModel : BroadcastMsgModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getCustomFields()
    }
    

    
    func getCustomFields() {
        self.startLoading()
        let param : [String : String] = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "view"]
        APICallManager.instance.requestForBroadcastMessagesList(param: param) { (res) in
            if res.success ?? false {
                self.broadcastMsgModel = res
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
        tblView.register(UINib(nibName: "BroadcastMsgSingleTableViewCell", bundle: nil), forCellReuseIdentifier: "BroadcastMsgSingleTableViewCell")
        
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
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddBroadcastMessagesVC") as! AddBroadcastMessagesVC
        controller.strTitleName = "Add Broadcast"
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
    
    @objc @IBAction func btnEditClicked(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddBroadcastMessagesVC") as! AddBroadcastMessagesVC
        controller.strTitleName = "Edit Broadcast"
        controller.type = 1
        controller.recordEdit = (broadcastMsgModel?.broadcastMessages?[sender.tag])!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc @IBAction func btnDeleteClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Infobuk", message: "Are you sure you want to delete broadcast?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            self.deleteBroadCast(index: sender.tag)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteBroadCast (index : Int) {
        self.startLoading()

        let catId =  (broadcastMsgModel?.broadcastMessages?[index].id ?? "")

        let param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "delete", "broadcastMessageId" : catId, "subject" : (broadcastMsgModel?.broadcastMessages?[index].subject ?? ""), "message" : (broadcastMsgModel?.broadcastMessages?[index].message ?? "")]

        APICallManager.instance.requestForBroadcastMessagesList(param: param) { (res) in
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

        }
    }

}

extension BroadcastMessagesListVC : UITableViewDelegate, UITableViewDataSource {
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
        return broadcastMsgModel?.broadcastMessages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "BroadcastMsgSingleTableViewCell", for: indexPath) as! BroadcastMsgSingleTableViewCell
        let record = broadcastMsgModel?.broadcastMessages?[indexPath.row]
        
        
        customCell.lblSubject.text = record?.subject ?? ""

        customCell.lblMsg.text = record?.message ?? ""
//        customCell.record = record!
        customCell.parentVC = self
        customCell.btnExpandCollapse.tag = indexPath.row
        customCell.btnEdit.tag = indexPath.row
        customCell.btnDelete.tag = indexPath.row
        customCell.btnExpandCollapse.addTarget(self, action: #selector(btnExpandClicked(_:)), for: .touchUpInside)
        customCell.btnEdit.addTarget(self, action: #selector(btnEditClicked(_:)), for: .touchUpInside)
        customCell.btnDelete.addTarget(self, action: #selector(btnDeleteClicked(_:)), for: .touchUpInside)
//        customCell.tagsModel = self.tagsModel
        
        if expandIndexList.contains(indexPath.row) {
            customCell.lblMsg.numberOfLines = 0
            customCell.btnExpandCollapse.setTitle("Read Less", for: .normal)
        } else {
            customCell.lblMsg.numberOfLines = 2
            customCell.btnExpandCollapse.setTitle("Read More", for: .normal)
        }
        let maxLine = customCell.lblMsg.calculateMaxLines()
        if maxLine <= 2 {
            customCell.btnExpandCollapse.isHidden = true
            customCell.cnstrntBtnExpandHeight.constant = 0.0

        } else {
            customCell.btnExpandCollapse.isHidden = false
            customCell.cnstrntBtnExpandHeight.constant = 22.0
        }

        return customCell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
}
