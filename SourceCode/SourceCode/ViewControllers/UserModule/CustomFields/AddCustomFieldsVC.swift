//
//  AddCustomFieldsVC.swift
//  SourceCode
//
//  Created by Apple on 03/01/22.
//

import UIKit
import MaterialComponents
import MaterialTextField

class AddCustomFieldsVC: MainViewController {

    @IBOutlet weak var txtFieldName: MDCOutlinedTextField!
    @IBOutlet weak var txtFieldType: MDCOutlinedTextField!
    @IBOutlet weak var txtFieldAddOption: MDCOutlinedTextField!
    
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var cnstrntHeightCollView: NSLayoutConstraint!

    @IBOutlet weak var btnAddOption: UIButton!

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTextSubjCount: UILabel!
    @IBOutlet weak var lblTextMessageCount: UILabel!
    
    @IBOutlet weak var imgIsUnique: UIImageView!


    @IBOutlet weak var lblTitle: UILabel!

    var type = 0 // 0 - add, 1 - Edit

    var strTitleName = ""
    var recordEdit : Fields?
    var optionsArray = [String]()
    var isUnique = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSave.backgroundColor = .lightGray
        self.btnSave.alpha = 0.5
        self.btnSave.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtFieldName.becomeFirstResponder()
    }
    
    func setUI (){
        collView.delegate = self
        collView.dataSource = self
        
        collView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collView.register(UINib(nibName: "CustomSelectionShowCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CustomSelectionShowCollectionCell")
        
        collView.isScrollEnabled = false
        
        self.txtFieldName.delegate = self
        self.txtFieldType.delegate = self
        self.txtFieldAddOption.delegate = self

        self.setUpTexxtField(textField: txtFieldName, errorText: "Please enter a valid name", placeHolder: "Field Name")
        self.setUpTexxtField(textField: txtFieldType, errorText: "Please enter a valid type", placeHolder: "Field Type")
        self.setUpTexxtField(textField: txtFieldAddOption, errorText: "Please enter a valid option", placeHolder: "Add Option")
        
        self.txtFieldAddOption.superview?.superview?.isHidden = true


//        txtField.viewBorder(borderColor: AppColor, borderWidth: 1.5)
//        txtField.setCornerRadius(radius: 8.0)
        
        btnSave.setCornerRadius(radius: 8.0)
        btnCancel.setCornerRadius(radius: 8.0)
        btnAddOption.setCornerRadius(radius: 8.0)

        lblTitle.text = strTitleName
        if (type == 0 ){
            btnSave.setTitle("   Save   ", for: .normal)
        } else {
            btnSave.setTitle("   Update   ", for: .normal)
        }
        
        if type == 1 {
            txtFieldName.text = recordEdit?.fieldName ?? ""
            txtFieldType.text = (recordEdit?.optionNames?.count ?? 0 > 0) ? "Options" : "Text"
            optionsArray = recordEdit?.optionNames ?? [String]()
            
            if (recordEdit?.optionNames?.count ?? 0 > 0) {
                self.txtFieldAddOption.superview?.superview?.isHidden = false
            }
            collView.reloadData()
            self.view.layoutIfNeeded()
            cnstrntHeightCollView.constant = max(collView.collectionViewLayout.collectionViewContentSize.height, 5.0)
            imgIsUnique.image = UIImage(named: isUnique ? "checkbox_app_selected" : "checkbox_unselected")

        }
   
        self.updateSaveButton()

        
    }
    
    func updateSaveButton() {
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if (self.txtFieldName.text?.count ?? 0 > 0) && (self.txtFieldType.text?.count ?? 0 > 0) && (self.txtFieldType.text! == "Options" ? (self.optionsArray.count > 0) : true) {
                self.btnSave.backgroundColor = AppColor
                self.btnSave.alpha = 1.0
                self.btnSave.isUserInteractionEnabled = true
            } else {
                self.btnSave.backgroundColor = .lightGray
                self.btnSave.alpha = 0.5
                self.btnSave.isUserInteractionEnabled = false
            }
            
            if self.txtFieldAddOption.text?.count ?? 0 > 0 {
                self.btnAddOption.backgroundColor = AppColor
                self.btnAddOption.alpha = 1.0
                self.btnAddOption.isUserInteractionEnabled = true
            } else {
                self.btnAddOption.backgroundColor = .lightGray
                self.btnAddOption.alpha = 0.5
                self.btnAddOption.isUserInteractionEnabled = false
            }
            self.lblTextSubjCount.text = "\(self.txtFieldName.text?.count ?? 0)/50"
            self.lblTextMessageCount.text = "\(self.txtFieldAddOption.text?.count ?? 0)/50"

        }
    }
    
   
    
    // MARK :- BUtton Action
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnIsUniqueClicked(_ sender: UIButton) {
        isUnique = !isUnique
        imgIsUnique.image = UIImage(named: isUnique ? "checkbox_app_selected" : "checkbox_unselected")
    }
    
    @IBAction func btnAddOptionsClicked(_ sender: Any) {
        if self.txtFieldAddOption.text?.count ?? 0 > 0 {
            let str = (txtFieldAddOption.text ?? "")
            if !optionsArray.contains(str){
                optionsArray.append(str)
                collView.reloadData()
                self.view.layoutIfNeeded()
                cnstrntHeightCollView.constant = max(collView.collectionViewLayout.collectionViewContentSize.height, 5.0)
                self.txtFieldAddOption.text = ""
            }
        }
    }
    
    @IBAction func btnFieldTypeClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Select Field Type", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Text", style: UIAlertAction.Style.default, handler: { (action) in
            self.txtFieldType.text = "Text"
            self.txtFieldAddOption.superview?.superview?.isHidden = true
            self.updateSaveButton()
            
            self.txtFieldAddOption.text = ""
            self.optionsArray.removeAll()
            self.collView.reloadData()
            self.view.layoutIfNeeded()
            self.cnstrntHeightCollView.constant = max(self.collView.collectionViewLayout.collectionViewContentSize.height, 5.0)
        }))
        alert.addAction(UIAlertAction(title: "Options", style: UIAlertAction.Style.default, handler: { (action) in
            self.txtFieldType.text = "Options"
            self.txtFieldAddOption.superview?.superview?.isHidden = false
            self.updateSaveButton()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        var param : [String : String] = [String: String]()
        self.startLoading()

        if type == 1 {
            param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "update", "fieldId" : recordEdit?.fieldId ?? "", "fieldName" : txtFieldName.text!, "fieldType" : txtFieldType.text!.lowercased(), "isUnique" : isUnique ? "1" : "0"]
            var i = 0
            for rec in optionsArray {
                param["optionNames[\(i)]"] = rec
                i = i + 1
            }
            APICallManager.instance.requestForCustomFieldsList(param: param) { (res) in
                if res.success ?? false {
                    self.showAlertWithBackAction(msg: "Success")
                } else {
                    self.showAlert(msg: res.error ?? "Something went wrong. Please try again.")
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()

            }
        } else if type == 0 { // for Add tag group
            param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "add", "fieldName" : txtFieldName.text!, "fieldType" : txtFieldType.text!.lowercased(), "isUnique" : isUnique ? "1" : "0"]
            var i = 0
            for rec in optionsArray {
                param["optionNames[\(i)]"] = rec
                i = i + 1
            }
            APICallManager.instance.requestForCustomFieldsList(param: param) { (res) in
                if res.success ?? false {
                    self.showAlertWithBackAction(msg: "Success")
                } else {
                    self.showAlert(msg: res.error ?? "Something went wrong. Please try again.")
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()

            }
        }
        
        
       
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        

//        let strId = optionsArray[sender.tag] ?? ""
//        if !deleteCategorySelected.contains(strId) && recordEdit != nil{
//            deleteCategorySelected.append(strId)
//        }
        
        optionsArray.remove(at: sender.tag)
        collView.reloadData()
        self.view.layoutIfNeeded()
        cnstrntHeightCollView.constant = max(collView.collectionViewLayout.collectionViewContentSize.height, 5.0)
    }

}

extension AddCustomFieldsVC : UITextFieldDelegate, UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtFieldName {
            if ((textField.text?.count ?? 0) == 50) && (string != "") {
                return false
            }
        } else if textField == txtFieldAddOption {
            if ((textField.text?.count ?? 0) == 50) && (string != "") {
                return false
            }
        }
        
        self.updateSaveButton()
        
        return true
    }
    

    
}


extension AddCustomFieldsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomSelectionShowCollectionCell", for: indexPath) as! CustomSelectionShowCollectionCell
        customCell.lblTitle.text = optionsArray[indexPath.row]

        customCell.btnDelete.tag = indexPath.row
        customCell.btnDelete.addTarget(self, action: #selector(btnDeleteClicked(_:)), for: .touchUpInside)
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SelectTagsVC") as! SelectTagsVC
//        controller.tagGroupArray = self.categoriesArray!
//        controller.parentVC = self
//        controller.displayTagGroupArray = self.categoriesArray!
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let font = UIFont(name: "OpenSans-SemiBold", size: 17) {
            let fontAttributes = [NSAttributedString.Key.font: font]
           let myText =  optionsArray[indexPath.row]
           let size = (myText as NSString).size(withAttributes: fontAttributes)
            let cgSize = CGSize(width: size.width + 45.0, height: 40.0)
            return cgSize
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
