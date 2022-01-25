//
//  AddPermissionVC.swift
//  SourceCode
//
//  Created by Apple on 31/12/21.
//

import UIKit
import MaterialComponents
import MaterialTextField

class AddPermissionVC: MainViewController {

    
    @IBOutlet weak var txtField: MDCOutlinedTextField!

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTextCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var cnstrntHeightCollView: NSLayoutConstraint!
    @IBOutlet weak var viewBgCollTags: UIView!

    
    @IBOutlet weak var imgViewSelection: UIImageView!
    @IBOutlet weak var imgBroadcastMsgSelection: UIImageView!
    @IBOutlet weak var imgTakeAttendanceSelection: UIImageView!

    var strTitleName = ""
    var type = 0 // 0 = Add permission, 1 = Edit Permission
    var recordEdit : Permission?
    
    var categoriesArray : [CategoriesAndValues]?
    var categorySelected  = [String]()
    var deleteCategorySelected  = [String]()

    var isCanView = false
    var isBroadcastMsgs = false
    var isTakeAttendance = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSave.backgroundColor = .lightGray
        self.btnSave.alpha = 0.5
        self.btnSave.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtField.becomeFirstResponder()
        viewBgCollTags.viewBorder(borderColor: .lightGray, borderWidth: 1.5)
        viewBgCollTags.layer.cornerRadius = 8.0
        self.updateSaveButton()
        checkForSelectedCategories()
    }
    
    func setUI (){
        let tap = UITapGestureRecognizer(target: self, action: #selector(btnAddTagClicked(_:)))
        collView.addGestureRecognizer(tap)
        
        collView.delegate = self
        collView.dataSource = self
        
        collView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collView.register(UINib(nibName: "CustomSelectionShowCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CustomSelectionShowCollectionCell")
        
        collView.isScrollEnabled = false
        
        self.setUpTexxtField(textField: txtField, errorText: "Please enter a valid name", placeHolder: "Friendly Permission Name")

//        txtField.viewBorder(borderColor: AppColor, borderWidth: 1.5)
//        txtField.setCornerRadius(radius: 8.0)
        
        btnSave.setCornerRadius(radius: 8.0)
        btnCancel.setCornerRadius(radius: 8.0)

        lblTitle.text = strTitleName
        if (type == 0 ){
            btnSave.setTitle("   Save   ", for: .normal)
        } else {
            btnSave.setTitle("   Update   ", for: .normal)
        }
        
        if type == 1 {
            txtField.text = recordEdit?.name ?? ""
            isCanView = (recordEdit?.canView ?? "0" == "1") ? true : false
            isBroadcastMsgs = (recordEdit?.canBroadcast ?? "0" == "1") ? true : false
            isTakeAttendance = (recordEdit?.canTakeAttendance ?? "0" == "1") ? true : false
            categorySelected = recordEdit?.categoryAndValueTags ?? [String]()
        }
        self.updateSaveButton()
        checkForSelectedCategoriesForEdit()
    }
    
    func updateSaveButton() {
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if (self.txtField.text?.count ?? 0 > 0 && self.categorySelected.count > 0) {
                self.btnSave.backgroundColor = AppColor
                self.btnSave.alpha = 1.0
                self.btnSave.isUserInteractionEnabled = true
            } else {
                self.btnSave.backgroundColor = .lightGray
                self.btnSave.alpha = 0.5
                self.btnSave.isUserInteractionEnabled = false
            }
            self.lblTextCount.text = "\(self.txtField.text?.count ?? 0)/50"
            
        }
        
        imgViewSelection.image = UIImage(named: isCanView ? "checkbox_app_selected" : "checkbox_unselected")
        imgBroadcastMsgSelection.image = UIImage(named: isBroadcastMsgs ? "checkbox_app_selected" : "checkbox_unselected")
        imgTakeAttendanceSelection.image = UIImage(named: isTakeAttendance ? "checkbox_app_selected" : "checkbox_unselected")
    }
    
    func checkForSelectedCategoriesForEdit() {
//        categorySelected.removeAll()
        
        var tagArray = [String]()
        var tagChildArray = [String]()

        for rec in categorySelected {
            let strId = rec ?? ""
            let strIdArray = strId.components(separatedBy: "_")
            if let strFirst = strIdArray.first as? String {
                if strFirst == "category" {
                    tagArray.append(strIdArray.last ?? "")
                } else if strFirst == "categoryValue" {
                    tagChildArray.append(strIdArray.last ?? "")
                }
            }
        }
        
        var i = 0
        for rec in (categoriesArray)! {
            if tagArray.contains(rec.id ?? "") {
                categoriesArray?[i].isSelected = true
//                var j = 0
//                for rec1 in rec.valuesSorted! {
//                    if tagChildArray.contains(rec1.id ?? "") {
//                        categoriesArray?[i].valuesSorted?[j].isSelected = false
//                    }
//                    j = j + 1
//                }
            } else {
                categoriesArray?[i].isSelected = false
            }
            
//                categoriesArray?[i].isSelected = false
                var j = 0
                for rec1 in rec.valuesSorted ?? [ValuesSorted]() {
                    if tagChildArray.contains(rec1.id ?? "") {
                        categoriesArray?[i].valuesSorted?[j].isSelected = true
                    } else {
                        categoriesArray?[i].valuesSorted?[j].isSelected = false
                    }
                    j = j + 1
                }
            
            i = i + 1
        }
        collView.reloadData()
        self.view.layoutIfNeeded()
        cnstrntHeightCollView.constant = max(collView.collectionViewLayout.collectionViewContentSize.height, 60.0)
    }
    
    func checkForSelectedCategories() {
        categorySelected.removeAll()
        
        for rec in (categoriesArray)! {
            if rec.isSelected {
                categorySelected.append("category_\(rec.id ?? "")")
            }
            
            for rec1 in rec.valuesSorted ?? [ValuesSorted]() {
                if rec1.isSelected {
                    categorySelected.append("categoryValue_\(rec1.id ?? "")")

                }
            }
            
        }
        collView.reloadData()
        self.view.layoutIfNeeded()
        cnstrntHeightCollView.constant = max(collView.collectionViewLayout.collectionViewContentSize.height, 60.0)
    }
    
    func getTagText(strId : String) -> String {
        for rec in (categoriesArray)! {
            for rec1 in rec.valuesSorted ?? [ValuesSorted]() {
                if rec1.id ?? "" == strId {
                    return "\(rec.name ?? "") : \(rec1.value ?? "")"
                }
            }
        }
        return strId
    }
    
    func getTagGroupText(strId : String) -> String {
        for rec in (categoriesArray)! {
            if rec.id ?? "" == strId {
                return (rec.name ?? "") + " (All)"
            }
        }
        return strId
    }
    
    // MARK :- BUtton Action
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCanViewClicked(_ sender: UIButton) {
        isCanView = !isCanView
        imgViewSelection.image = UIImage(named: isCanView ? "checkbox_app_selected" : "checkbox_unselected")
    }
    
    @IBAction func btnBroadcastMsgs(_ sender: UIButton) {
        isBroadcastMsgs = !isBroadcastMsgs
        imgBroadcastMsgSelection.image = UIImage(named: isBroadcastMsgs ? "checkbox_app_selected" : "checkbox_unselected")
    }
    
    @IBAction func btnTakeAttendance(_ sender: UIButton) {
        isTakeAttendance = !isTakeAttendance
        imgTakeAttendanceSelection.image = UIImage(named: isTakeAttendance ? "checkbox_app_selected" : "checkbox_unselected")
    }
    
    @IBAction func btnAddTagClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SelectTagsVC") as! SelectTagsVC
        controller.tagGroupArray = self.categoriesArray!
        controller.parentVC = self
        controller.displayTagGroupArray = self.categoriesArray!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        var tagArray = [String]()
        var tagChildArray = [String]()

        let strId = categorySelected[sender.tag] ?? ""
        if !deleteCategorySelected.contains(strId) && recordEdit != nil{
            deleteCategorySelected.append(strId)
        }
        
        let strIdArray = strId.components(separatedBy: "_")
        if let strFirst = strIdArray.first as? String {
            if strFirst == "category" {
                tagArray.append(strIdArray.last ?? "")
            } else if strFirst == "categoryValue" {
                tagChildArray.append(strIdArray.last ?? "")
            }
        }
        
        var i = 0
        for rec in (categoriesArray)! {
            if tagArray.contains(rec.id ?? "") {
                categoriesArray?[i].isSelected = false
                var j = 0
                for _ in rec.valuesSorted ?? [ValuesSorted]() {
                    categoriesArray?[i].valuesSorted?[j].isSelected = false
                    j = j + 1
                }
            } else {
                var j = 0
                for rec1 in rec.valuesSorted ?? [ValuesSorted]() {
                    if tagChildArray.contains(rec1.id ?? "") {
                        categoriesArray?[i].valuesSorted?[j].isSelected = false
                    }
                    j = j + 1
                }
            }
            i = i + 1
        }
        categorySelected.remove(at: sender.tag)
        collView.reloadData()
        self.view.layoutIfNeeded()
        cnstrntHeightCollView.constant = max(collView.collectionViewLayout.collectionViewContentSize.height, 60.0)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        var param : [String : String] = [String: String]()
        self.startLoading()
        let strCatArray = categorySelected.joined(separator: ",")
        if type == 1 { // for edit
            param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "update", "permissionName" : txtField.text!, "permissionId" : recordEdit?.id ?? "", "canView" : isCanView ? "1" : "0", "canBroadcast" : isBroadcastMsgs ? "1" : "0", "canTakeAttendance" : isTakeAttendance ? "1" : "0"]
            
            if deleteCategorySelected.count > 0 {
                var indexArray = [Int]()
                for index in 0...(deleteCategorySelected.count-1) {
                    if categorySelected.contains(deleteCategorySelected[index]){
                        indexArray.append(index)
    //                    deleteCategorySelected.remove(at: deleteCategorySelected.firstIndex(of: deleteCategorySelected[index])!)
                    }
                }
                deleteCategorySelected.remove(at: indexArray)
                var j = 0
                for rec in deleteCategorySelected {
                    param["categoryAndValueTagsRemove[\(j)]"] = rec
                    j = j + 1
                }
            }
            
            
            
            var i = 0
            for rec in categorySelected {
                param["categoryAndValueTagsAdd[\(i)]"] = rec
                i = i + 1
            }
            

            
            APICallManager.instance.requestForPermissionList(param: param) { (res) in
                if res.success ?? false {
                    self.navigationController?.popViewController(animated: true)
//                    self.showAlertWithBackAction(msg: "Success")
                    
                } else {
                    self.showAlert(msg: res.error ?? "Something went wrong. Please try again.")
                }
                self.stopLoading()
            } onFailure: { (err) in
                self.stopLoading()
                self.showAlert(msg: err)

            }
        } else if type == 0 { // for Add
            param  = [ "orgId" : "\(APP_DEL.userSelectedDict["orgId"] ?? "")","userId" : "\(APP_DEL.userSelectedDict["userId"] ?? "")","action" : "add", "permissionName" : txtField.text!, "canView" : isCanView ? "1" : "0", "canBroadcast" : isBroadcastMsgs ? "1" : "0", "canTakeAttendance" : isTakeAttendance ? "1" : "0"]
            var i = 0
            for rec in categorySelected {
                param["categoryAndValueTagsAdd[\(i)]"] = rec
                i = i + 1
            }
            APICallManager.instance.requestForPermissionList(param: param) { (res) in
                if res.success ?? false {
                    self.navigationController?.popViewController(animated: true)
//                    self.showAlertWithBackAction(msg: "Success")
                    
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
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}

extension AddPermissionVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.count ?? 0) == 50) && (string != "") {
            return false
        }
        
        self.updateSaveButton()
        
        return true
    }
    
}

extension AddPermissionVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorySelected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomSelectionShowCollectionCell", for: indexPath) as! CustomSelectionShowCollectionCell
        let strId = categorySelected[indexPath.row]
        let strIdArray = strId.components(separatedBy: "_")
        if let strFirst = strIdArray.first as? String {
            if strFirst == "category" {
                customCell.lblTitle.text = self.getTagGroupText(strId: strIdArray.last ?? "")
            } else if strFirst == "categoryValue" {
                customCell.lblTitle.text = self.getTagText(strId: strIdArray.last ?? "")
            }
        }
        customCell.btnDelete.tag = indexPath.row
        customCell.btnDelete.addTarget(self, action: #selector(btnDeleteClicked(_:)), for: .touchUpInside)
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SelectTagsVC") as! SelectTagsVC
        controller.tagGroupArray = self.categoriesArray!
        controller.parentVC = self
        controller.displayTagGroupArray = self.categoriesArray!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let font = UIFont(name: "OpenSans-SemiBold", size: 17) {
            let fontAttributes = [NSAttributedString.Key.font: font]
           var myText = ""
            let strId = categorySelected[indexPath.row]
            let strIdArray = strId.components(separatedBy: "_")
            if let strFirst = strIdArray.first as? String {
                if strFirst == "category" {
                    myText = self.getTagGroupText(strId: strIdArray.last ?? "")
                } else if strFirst == "categoryValue" {
                    myText = self.getTagText(strId: strIdArray.last ?? "")
                }
            }
           let size = (myText as NSString).size(withAttributes: fontAttributes)
            let cgSize = CGSize(width: size.width + 40.0, height: 40.0)
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

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
