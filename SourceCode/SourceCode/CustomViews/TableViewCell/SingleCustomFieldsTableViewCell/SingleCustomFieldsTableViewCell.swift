//
//  SingleCustomFieldsTableViewCell.swift
//  SourceCode
//
//  Created by Apple on 01/01/22.
//

import UIKit

class SingleCustomFieldsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainStackViewBg: UIStackView!

    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblFieldType: UILabel!
    @IBOutlet weak var lblOptions: UILabel!

    
    @IBOutlet weak var btnExpandCollapse: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var cnstrntHeightCollView: NSLayoutConstraint!

    
    @IBOutlet weak var imgUnique: UIImageView!
    @IBOutlet weak var btnInfo1: UIButton!
    @IBOutlet weak var btnInfo2: UIButton!
    @IBOutlet weak var btnInfo3: UIButton!
    
    var parentVC : MainViewController?
    var index = 0
    var record : Fields?
    var tagsModel : TagsModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        
//        collView.collectionViewLayout = FlowLayout()
        collView.register(UINib(nibName: "CustomSelectionShowCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CustomSelectionShowCollectionCell")
        
        collView.isScrollEnabled = false
        
        mainStackViewBg.layer.borderWidth = 0.5
        mainStackViewBg.layer.borderColor = UIColor.lightGray.cgColor
        mainStackViewBg.layer.cornerRadius = 8.0
        mainStackViewBg.layer.masksToBounds = true
        
        bottomView.isHidden = false
        
    }
    
    func reloadBottomData() {
        if (record?.optionNames?.count ?? 0 <= 0){
            collView.isHidden = true
            lblOptions.isHidden = true
        } else {
            collView.isHidden = false
            lblOptions.isHidden = false
        }

        collView.reloadData()
        self.layoutIfNeeded()
        cnstrntHeightCollView.constant = collView.collectionViewLayout.collectionViewContentSize.height
        
        imgUnique.image = UIImage(named: "checkbox_unselected")


        if (record?.isUnique == "1"){
            imgUnique.image = UIImage(named: "checkbox_app_selected")
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getTagText(strId : String) -> String {
        for rec in (tagsModel?.categoriesAndValues)! {
            for rec1 in rec.valuesSorted! {
                if rec1.id ?? "" == strId {
                    return "\(rec.name ?? "") : \(rec1.value ?? "")"
                }
            }
        }
        return strId
    }
    
    func getTagGroupText(strId : String) -> String {
        for rec in (tagsModel?.categoriesAndValues)! {
            if rec.id ?? "" == strId {
                return (rec.name ?? "") + " (All)"
            }
        }
        return strId
    }
    
    // MARK :- BUtton Action
    @IBAction func btnInfoClicked(_ sender: Any) {
        let controller = parentVC?.storyboard?.instantiateViewController(withIdentifier: "InfoWebviewVC") as! InfoWebviewVC
        controller.strTitle = "Custom Fields"
        controller.htmlData = "<p>Custom fields help you to add information to contacts which isn't provided by default.</p><p>You can add all kinds of information like Passport numbers, Roll numbers, Driving License, Address etc.</p> <p><strong>Field Name</strong><br />Name of the field as is seen by all users. Eg. \"Roll no.\", \"Address\"</p><ol class=\"list-unstyled\"><li><strong>Field Type</strong><ol><li><strong>Text</strong>&nbsp;- For small amount of text eg. Driving License, City etc. (Limited to 250 characters)</li><li><strong>Options</strong>&nbsp;- For small set of predefined categories - eg: Gender (Male, Female, other)</li></ol></li></ol><p><strong>Unique field</strong><br />For fields which can't be duplicate, eg. Registration ID, Driving License, National ID</p>"
        parentVC?.navigationController?.present(controller, animated: true, completion: nil)
    }
    
}

extension SingleCustomFieldsTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return record?.optionNames?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomSelectionShowCollectionCell", for: indexPath) as! CustomSelectionShowCollectionCell
        customCell.lblTitle.text = record?.optionNames?[indexPath.row] ?? ""
        customCell.btnDelete.superview?.isHidden = true
//        let strId = record?.optionNames?[indexPath.row] ?? ""
//        let strIdArray = strId.components(separatedBy: "_")
//        if let strFirst = strIdArray.first as? String {
//            if strFirst == "category" {
//                customCell.lblTitle.text = self.getTagGroupText(strId: strIdArray.last ?? "")
//            } else if strFirst == "categoryValue" {
//                customCell.lblTitle.text = self.getTagText(strId: strIdArray.last ?? "")
//            }
//        }
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let font = UIFont(name: "OpenSans-SemiBold", size: 15) {
            let fontAttributes = [NSAttributedString.Key.font: font]
           let myText = record?.optionNames?[indexPath.row] ?? ""
           let size = (myText as NSString).size(withAttributes: fontAttributes)
            let cgSize = CGSize(width: size.width + 30.0, height: 40.0)
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
