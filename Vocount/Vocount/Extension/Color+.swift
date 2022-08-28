//
//  Color+.swift
//  Vocount
//
//  Created by 지준용 on 2022/08/28.
//

import UIKit

extension UIColor {
    static let textColor: UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    static let mainColor: UIColor = UIColor(red: 108, green: 227, blue: 250, alpha: 1)
    static let subColor: UIColor = UIColor(red: 102, green: 102, blue: 221, alpha: 0.5)
    static let backgroundMainColor: UIColor = UIColor(red: 23, green: 23, blue: 23, alpha: 1)
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
}

extension UIView {
    func setGradient(startColor: UIColor, mediumColor: UIColor, lastColor: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, mediumColor.cgColor, lastColor.cgColor]
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
