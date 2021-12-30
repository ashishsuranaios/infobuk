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

    
    var parentVC : MainViewController?
    var index = 0
    
    
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
        collView.reloadData()
        self.layoutIfNeeded()
        cnstrntHeightCollView.constant = collView.collectionViewLayout.collectionViewContentSize.height
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CustomSinglePermissionTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomSelectionShowCollectionCell", for: indexPath) as! CustomSelectionShowCollectionCell
        customCell.lblTitle.text = "Best:best"
   
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let font = UIFont(name: "OpenSans-SemiBold", size: 15) {
            let fontAttributes = [NSAttributedString.Key.font: font]
           let myText = "Best:best"
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
