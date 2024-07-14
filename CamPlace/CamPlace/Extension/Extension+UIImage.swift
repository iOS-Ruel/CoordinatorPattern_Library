//
//  Extension+UIImage.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/17/24.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func circularImage(withBorderWidth borderWidth: CGFloat, borderColor: UIColor) -> UIImage? {
        let minEdge = min(size.width, size.height)
        let squareSize = CGSize(width: minEdge, height: minEdge)
        let imageSize = CGSize(width: squareSize.width + borderWidth * 2, height: squareSize.height + borderWidth * 2)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        // Draw border circle
        let borderRect = CGRect(origin: .zero, size: imageSize)
        context?.addEllipse(in: borderRect)
        context?.setFillColor(borderColor.cgColor)
        context?.fillPath()
        
        // Draw inner circle
        let innerRect = CGRect(x: borderWidth, y: borderWidth, width: squareSize.width, height: squareSize.height)
        context?.addEllipse(in: innerRect)
        context?.clip()
        
        self.draw(in: innerRect)
        
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return circularImage
    }
}
