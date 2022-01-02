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
        shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 8, y: 8, width: bounds.width-16, height: bounds.height-16), cornerRadius: 12).cgPath
         shadowLayer.fillColor = UIColor.white.cgColor

         shadowLayer.shadowColor = UIColor.lightGray.cgColor
         shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = radius

         layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func setCornerRadius(radius : CGFloat) {
     
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
    }
}


extension String {
    
    func capitalizingFirstLetter() -> String {
            let first = String(self.prefix(1)).capitalized
            let other = String(self.dropFirst())
            return first + other
        }

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

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}

extension Array {
    mutating func remove(at indexes: [Int]) {
        var lastIndex: Int? = nil
        for index in indexes.sorted(by: >) {
            guard lastIndex != index else {
                continue
            }
            remove(at: index)
            lastIndex = index
        }
    }
}
