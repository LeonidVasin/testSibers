//
//  Common.swift
//  SibersTest
//
//  Created by user on 06.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit

extension UIColor {
    open class var disable: UIColor { return UIColor(red: 203.0/255.0, green: 203.0/255.0, blue: 203.0/255.0, alpha: 1.0)}
    
    open class var enable: UIColor { return UIColor(red: 0.0, green: 111.0/255.0, blue: 1.0, alpha: 1.0)}
}

extension UIImage {
    func fixOrientation() -> UIImage
    {
        
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi));
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0);
            transform = transform.rotated(by: CGFloat(Double.pi/2));
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi/2));
            
        case .up, .upMirrored:
            break
        }
        
        
        switch self.imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1);
            
        default:
            break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(
            data: nil,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: self.cgImage!.bitsPerComponent,
            bytesPerRow: 0,
            space: self.cgImage!.colorSpace!,
            bitmapInfo: UInt32(self.cgImage!.bitmapInfo.rawValue)
        )
        
        
        
        ctx!.concatenate(transform);
        
        switch self.imageOrientation {
            
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx?.draw(self.cgImage!, in: CGRect(x:0 ,y: 0 ,width: self.size.height ,height:self.size.width))
            
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x:0 ,y: 0 ,width: self.size.width ,height:self.size.height))
            break;
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = ctx!.makeImage()
        
        let img = UIImage(cgImage: cgimg!)
        
        return img;
        
    }
}
