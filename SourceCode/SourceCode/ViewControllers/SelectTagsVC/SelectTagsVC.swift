//
//  SelectTagsVC.swift
//  SourceCode
//
//  Created by Apple on 01/01/22.
//

import UIKit

class SelectTagsVC: UIViewController {


    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!


    var tagGroupArray = [CategoriesAndValues]()
    var displayTagGroupArray = [CategoriesAndValues]()

    var selectedPhoneCode : PhoneCode?
    var parentVC : UIViewController?
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtSearch.delegate = self
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "SelectionImglblTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionImglblTableViewCell")
        txtSearch.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .allEditingEvents)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setUI()
    }
    
    
    func setUI(){
        tblView.reloadData()
    }
    
    // MARK :- BUtton Action
    @IBAction func btnBackClicked(_ sender: Any) {
        (self.parentVC as! AddPermissionVC).categoriesArray = tagGroupArray
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc @IBAction func btnSelectionTagGroupClicked(_ sender: UIButton) {
        if displayTagGroupArray.count > 0 {
            let isSelected = !displayTagGroupArray[sender.tag].isSelected
            displayTagGroupArray[sender.tag].isSelected = isSelected
            
            var i = 0
            let strId = displayTagGroupArray[sender.tag].id ?? ""
            for rec in tagGroupArray {
                if strId == rec.id ?? "" {
                    tagGroupArray[i].isSelected = isSelected
                    var j = 0
                    for rec1 in tagGroupArray[i].valuesSorted ?? [ValuesSorted]() {
                        tagGroupArray[i].valuesSorted?[j].isSelected = false
                        j = j + 1
                    }
                    
                    var k = 0
                    for rec1 in displayTagGroupArray[sender.tag].valuesSorted ?? [ValuesSorted]() {
                        displayTagGroupArray[sender.tag].valuesSorted?[k].isSelected = false
                        k = k + 1
                    }
                }
                i = i + 1
            }
        } else {
            let isSelected = !tagGroupArray[sender.tag].isSelected
            tagGroupArray[sender.tag].isSelected = isSelected
        }
        tblView.reloadData()
    }
    
    @objc @IBAction func btnTagChildSelectionClicked(_ sender: CustomButton) {
        if displayTagGroupArray.count > 0 {
            let isSelected = !(displayTagGroupArray[sender.section].valuesSorted?[sender.tag].isSelected ?? false)
            displayTagGroupArray[sender.section].valuesSorted?[sender.tag].isSelected = isSelected
            
            if isSelected == false {
                displayTagGroupArray[sender.section].isSelected = false
            }
            var isAllChildTagSelected = true
            for rec1 in displayTagGroupArray[sender.section].valuesSorted ?? [ValuesSorted]() {
                if isAllChildTagSelected && !(rec1.isSelected){
                    isAllChildTagSelected = false
                }
            }
            displayTagGroupArray[sender.section].isSelected = isAllChildTagSelected
            if isAllChildTagSelected {
                var i = 0
                for _ in displayTagGroupArray[sender.section].valuesSorted ?? [ValuesSorted]() {
                    displayTagGroupArray[sender.section].valuesSorted![i].isSelected = false
                    i = i + 1
                }
            }
            
            var i = 0
            let strTaggrpId = displayTagGroupArray[sender.section].id ?? ""
            for rec in tagGroupArray {
                if strTaggrpId == rec.id ?? "" {
                    var j = 0
                    for rec1 in tagGroupArray[i].valuesSorted ?? [ValuesSorted]() {
                        let strTagId = displayTagGroupArray[sender.section].valuesSorted?[sender.tag].id ?? ""
                        if strTagId == rec1.id ?? "" {
                            tagGroupArray[i].valuesSorted?[j].isSelected = isSelected
                            if isSelected == false {
                                tagGroupArray[i].isSelected = false
                            }
                            var isAllChildTagSelected = true
                            for rec1 in tagGroupArray[i].valuesSorted ?? [ValuesSorted]() {
                                if isAllChildTagSelected && !(rec1.isSelected){
                                    isAllChildTagSelected = false
                                }
                            }
                            tagGroupArray[i].isSelected = isAllChildTagSelected
                            if isAllChildTagSelected {
                                var k = 0
                                for _ in tagGroupArray[i].valuesSorted ?? [ValuesSorted]() {
                                    tagGroupArray[i].valuesSorted![k].isSelected = false
                                    k = k + 1
                                }
                            }
                        }
                        j = j + 1
                    }
                    
                }
                i = i + 1
            }
        } else {
            let isSelected = !tagGroupArray[sender.tag].isSelected
            tagGroupArray[sender.tag].isSelected = isSelected
        }
        tblView.reloadData()
    }
    

    

}

extension SelectTagsVC : UITextFieldDelegate {
    @objc func textFieldValueChanged(textField : UITextField) {
        if ((txtSearch.text!.count <= 0)){
            displayTagGroupArray = tagGroupArray
        } else {
            var i = 0
            for rec in (tagGroupArray) {
                var strSearchString = rec.name ?? ""
                for rec1 in rec.valuesSorted ?? [ValuesSorted]() {
                    strSearchString = "\(strSearchString) \(rec1.value ?? "")"
                }
                tagGroupArray[i].searchString = strSearchString
                i = i + 1
            }
            var j = 0
            for rec in (tagGroupArray) {
                print("Tag Search String \(j) ===> \(rec.searchString) ")
                j = j + 1

            }
            let filterServices = tagGroupArray.filter({($0.searchString).lowercased().range(of: self.txtSearch.text!.lowercased()) != nil})
            displayTagGroupArray = filterServices
        }
        tblView.reloadData()
    }
}


extension SelectTagsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return displayTagGroupArray.count

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return displayTagGroupArray[section].valuesSorted?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var recordTag : CategoriesAndValues?
        if ((txtSearch.text!.count <= 0)){
            recordTag = displayTagGroupArray[section]
        } else {
            recordTag = displayTagGroupArray[section]
        }
        let view = (Bundle.main.loadNibNamed("SelectionImglblView", owner: self, options: nil))?.first as!  SelectionImglblView
        view.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 38)
        view.backgroundColor =  .white
        view.lblTitle.text = recordTag?.name ?? ""
        view.btnTagGroup.tag = section
        view.btnTagGroup.addTarget(self, action: #selector(btnSelectionTagGroupClicked(_:)), for: .touchUpInside)
        
        if (recordTag?.isSelected ?? false) {
            view.imgSelection.image = UIImage(named: "checkbox_app_selected")
        } else {
            view.imgSelection.image = UIImage(named: "checkbox_unselected")
        }
        view.cnstrntLeading.constant = 0.0
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "SelectionImglblTableViewCell", for: indexPath) as! SelectionImglblTableViewCell
        if let rec = displayTagGroupArray[indexPath.section].valuesSorted?[indexPath.row] {
            customCell.lblTitle.text = "\(rec.value ?? "")"
            customCell.selectionStyle = .none
            customCell.cnstrntLeading.constant = 15.0
            
            customCell.btnTagSelection.section = indexPath.section
            customCell.btnTagSelection.tag = indexPath.row
            customCell.btnTagSelection.addTarget(self, action: #selector(btnTagChildSelectionClicked(_:)), for: .touchUpInside)
            if (rec.isSelected || displayTagGroupArray[indexPath.section].isSelected) {
                customCell.imgSelection.image = UIImage(named: "checkbox_app_selected")
            } else {
                customCell.imgSelection.image = UIImage(named: "checkbox_unselected")
            }
            return customCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 38
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rec = displayTagGroupArray[indexPath.row]

//        if parentVC is RegisterVC {
//            (parentVC as! RegisterVC).selectedPhoneCode = rec
//            (parentVC as! RegisterVC).txtCode.text = "\(rec.phoneCode ?? "") \(rec.name ?? "")"
//            self.navigationController?.popViewController(animated: true)
//        } else if parentVC is AddOrganisationVC {
//            (parentVC as! AddOrganisationVC).selectedPhoneCode = rec
//            (parentVC as! AddOrganisationVC).txtCode.text = "\(rec.phoneCode ?? "") \(rec.name ?? "")"
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
}
