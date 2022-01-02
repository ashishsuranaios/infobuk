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
