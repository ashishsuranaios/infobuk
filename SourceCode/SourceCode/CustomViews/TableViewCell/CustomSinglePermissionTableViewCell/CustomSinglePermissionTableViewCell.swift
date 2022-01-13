//
//  CustomSinglePermissionTableViewCell.swift
//  SourceCode
//
//  Created by Apple on 30/12/21.
//

import UIKit

class CustomSinglePermissionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainStackViewBg: UIStackView!

    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnExpandCollapse: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var cnstrntHeightCollView: NSLayoutConstraint!

    
    @IBOutlet weak var imgViewSelection: UIImageView!
    @IBOutlet weak var imgBroadcastMsgSelection: UIImageView!
    @IBOutlet weak var imgTakeAttendanceSelection: UIImageView!

    
    var parentVC : MainViewController?
    var index = 0
    var record : Permission?
    var tagsModel : TagsModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        
        collView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collView.register(UINib(nibName: "CustomSelectionShowCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CustomSelectionShowCollectionCell")
        
        collView.isScrollEnabled = false
        
        mainStackViewBg.layer.borderWidth = 0.5
        mainStackViewBg.layer.borderColor = UIColor.lightGray.cgColor
        mainStackViewBg.layer.cornerRadius = 8.0
        mainStackViewBg.layer.masksToBounds = true
        
        bottomView.isHidden = false
        
    }
    
    func reloadBottomData() {
        collView.reloadData()
        self.layoutIfNeeded()
        cnstrntHeightCollView.constant = collView.collectionViewLayout.collectionViewContentSize.height
        
        imgViewSelection.image = UIImage(named: "checkbox_unselected")
        imgBroadcastMsgSelection.image = UIImage(named: "checkbox_unselected")
        imgTakeAttendanceSelection.image = UIImage(named: "checkbox_unselected")

        if (record?.canView == "1"){
            imgViewSelection.image = UIImage(named: "checkbox_app_selected")
        }
        if (record?.canBroadcast == "1"){
            imgBroadcastMsgSelection.image = UIImage(named: "checkbox_app_selected")
        }
        if (record?.canTakeAttendance == "1"){
            imgTakeAttendanceSelection.image = UIImage(named: "checkbox_app_selected")
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getTagText(strId : String) -> String {
        for rec in (tagsModel?.categoriesAndValues)! {
            for rec1 in rec.valuesSorted ?? [ValuesSorted]() {
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

extension CustomSinglePermissionTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return record?.categoryAndValueTags?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomSelectionShowCollectionCell", for: indexPath) as! CustomSelectionShowCollectionCell
        customCell.lblTitle.text = record?.categoryAndValueTags?[indexPath.row] ?? ""
        let strId = record?.categoryAndValueTags?[indexPath.row] ?? ""
        let strIdArray = strId.components(separatedBy: "_")
        if let strFirst = strIdArray.first as? String {
            if strFirst == "category" {
                customCell.lblTitle.text = self.getTagGroupText(strId: strIdArray.last ?? "")
            } else if strFirst == "categoryValue" {
                customCell.lblTitle.text = self.getTagText(strId: strIdArray.last ?? "")
            }
        }
        customCell.btnDelete.superview?.isHidden = true
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let font = UIFont(name: "OpenSans-SemiBold", size: 15) {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let strId = record?.categoryAndValueTags?[indexPath.row] ?? ""
            let strIdArray = strId.components(separatedBy: "_")
            var myText = ""
            if let strFirst = strIdArray.first as? String {
                if strFirst == "category" {
                    myText = self.getTagGroupText(strId: strIdArray.last ?? "")
                } else if strFirst == "categoryValue" {
                    myText = self.getTagText(strId: strIdArray.last ?? "")
                }
            }
//           let myText = record?.categoryAndValueTags?[indexPath.row] ?? ""
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

class FlowLayout: UICollectionViewFlowLayout {
   func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
    let attributesForElementsInRect = super.layoutAttributesForElements(in: rect)
    var newAttributesForElementsInRect = [AnyObject]()
    // use a value to keep track of left margin
    var leftMargin: CGFloat = 0.0;
    for attributes in attributesForElementsInRect! {
        let refAttributes = attributes
      // assign value if next row
      if (refAttributes.frame.origin.x == self.sectionInset.left) {
        leftMargin = self.sectionInset.left
      } else {
        // set x position of attributes to current margin
        var newLeftAlignedFrame = refAttributes.frame
        newLeftAlignedFrame.origin.x = leftMargin
        refAttributes.frame = newLeftAlignedFrame
      }
      // calculate new value for current margin
      leftMargin += refAttributes.frame.size.width
      newAttributesForElementsInRect.append(refAttributes)
    }
    return newAttributesForElementsInRect
  }
}
