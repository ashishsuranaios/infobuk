//
//  ExtentionsFiles.swift
//  SourceCode
//
//  Created by Ashish on 30/11/21.
//

import Foundation
import UIKit

extension UIView {
    func setShodowEffectWithCornerRadius(radius : CGFloat) {
        var shadowLayer: CAShapeLayer!
        shadowLayer = CAShapeLayer()
         shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
         shadowLayer.fillColor = UIColor.white.cgColor

         shadowLayer.shadowColor = UIColor.darkGray.cgColor
         shadowLayer.shadowPath = shadowLayer.path
         shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
         shadowLayer.shadowOpacity = 0.8
        shadowLayer.shadowRadius = radius

         layer.insertSublayer(shadowLayer, at: 0)
    }
}
