//
//  UIImage-Extension.swift
//  YoutubeApp
//
//  Created by 五十嵐慎吉 on 2020/11/04.
//

import Foundation
import UIKit



extension UIImage {
    //画像をresizeするメソッド
    func resize(size _size: CGSize) -> UIImage? {
            let widthRatio = _size.width / size.width
            let heightRatio = _size.height / size.height
            let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
            
            let resizeSize = CGSize(width: size.width * ratio, height: size.height * ratio)
            
            UIGraphicsBeginImageContextWithOptions(resizeSize, false, 0.0)
            draw(in: CGRect(origin: .zero, size: resizeSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resizedImage
        }
}
