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

         shadowLayer.shadowColor = UIColor.lightGray.cgColor
         shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = radius

         layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func setCornerRadius(radius : CGFloat) {
     
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
    }
}


extension String {

    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }

    //Validate Email

    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }

    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil){

                if(self.count>=6 && self.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
}

extension UIColor {
    
}
