//
//  FiltersInteractor.swift
//  SibersTest
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit

class FiltersInteractor: FiltersInteractorInput {

    weak var output: FiltersInteractorOutput!
    fileprivate var originalImage: UIImage?
    fileprivate var filterImage: UIImage?
    fileprivate var timeRendering: Double = 0
    fileprivate var timer: Timer?
    fileprivate var currentTimeRendering: Double = 0
    fileprivate let timeInteral: Double = 0.1
    
    func getRandomNumber() -> Double {
        return Double(arc4random_uniform(26)) + 5
    }
    
    @objc func updateTime() {
        currentTimeRendering += timeInteral
        DispatchQueue.main.async {
            self.output.updateTime(at: self.currentTimeRendering/self.timeRendering)
        }
        
        if currentTimeRendering >= timeRendering {
            timer?.invalidate()
            timer = nil
            DispatchQueue.main.async {
                self.output.setupFiltered(self.filterImage)
            }
        }
    }
    
    //MARK: - Input protocol
    
    func isValidateTimer() -> Bool {
        return timer != nil
    }
    
    func isOriginalImage() -> Bool {
        return originalImage == nil ? false : true
    }
    
    func apply(_ filter: Filter) {
        self.timeRendering = self.getRandomNumber()
        self.currentTimeRendering = 0.0
        self.timer = Timer.scheduledTimer(timeInterval: self.timeInteral, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        DispatchQueue.global(qos: .default).async {
            
            switch filter {
            case .rotate:
                self.filterImage = self.applyRotateFilter()
            case .blackWhite:
                self.filterImage = self.applyBlackWhiteFilter()
            case .mirror:
                self.filterImage = self.applyMirrorFilter()
            case .invertion:
                self.filterImage = self.applyInvertionFilter()
            case .mirrorLeftOnRight:
                self.filterImage = self.applyMirrorLeftOnRightFilter()
            }
        }
    }
    
    func removeFilterImage() {
        filterImage = nil
    }
    
    func setOriginal(_ image: UIImage) {
        originalImage = image
    }
    
    func getFilterImage() -> UIImage? {
        return filterImage
    }
    
    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(filterImage!, nil, nil, nil)
    }
}

extension FiltersInteractor {
    //MARK: - Filtration image -
    func applyRotateFilter() -> UIImage? {
        let size = originalImage?.size ?? .zero
        let rotatedSize = CGSize(width: size.height, height: size.width)
        
        UIGraphicsBeginImageContext(rotatedSize)
        if let bitmap: CGContext = UIGraphicsGetCurrentContext() {
            bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            bitmap.rotate(by: (90.0 * .pi / 180.0))
            bitmap.scaleBy(x: 1.0, y: -1.0)
            
            let origin = CGPoint(x: -size.width / 2, y: -size.height / 2)
            guard let cgImage = originalImage?.cgImage else {
                UIGraphicsEndImageContext()
                return nil
            }
            bitmap.draw(cgImage, in: CGRect(origin: origin, size: size))
            
            let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        UIGraphicsEndImageContext()
        return nil
    }
    
    func applyBlackWhiteFilter() -> UIImage? {
        if let filter = CIFilter(name: "CIPhotoEffectMono") {
            let ciInput = CIImage(image: originalImage!)
            filter.setValue(ciInput, forKey: "inputImage")
            
            guard let ciOutput = filter.outputImage else {
                return nil
            }
            
            let ciContext = CIContext()
            guard let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent) else {
                return nil
            }
            
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    func applyMirrorFilter() -> UIImage? {
        let size = originalImage?.size ?? .zero
        
        UIGraphicsBeginImageContext(size)
        if let bitmap: CGContext = UIGraphicsGetCurrentContext() {
            bitmap.translateBy(x: size.width, y: size.height)
            bitmap.scaleBy(x: -1.0, y: -1.0)
            
            guard let cgImage = originalImage?.cgImage else {
                UIGraphicsEndImageContext()
                return nil
            }
            bitmap.draw(cgImage, in: CGRect(origin: .zero, size: size))
            
            let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        UIGraphicsEndImageContext()
        return nil
    }
    
    func applyInvertionFilter() -> UIImage? {
        if let filter = CIFilter(name: "CIColorInvert") {
            let ciInput = CIImage(image: originalImage!)
            filter.setValue(ciInput, forKey: "inputImage")
            
            guard let ciOutput = filter.outputImage else {
                return nil
            }
            
            let ciContext = CIContext()
            guard let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent) else {
                return nil
            }
            
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    func applyMirrorLeftOnRightFilter() -> UIImage? {
        let size = originalImage?.size ?? .zero
        let rightPatSize = CGSize(width: size.width/2, height: size.height)
        UIGraphicsBeginImageContext(rightPatSize)
        if let bitmap: CGContext = UIGraphicsGetCurrentContext() {
            bitmap.translateBy(x: rightPatSize.width, y: rightPatSize.height)
            bitmap.scaleBy(x: -1.0, y: -1.0)
            
            guard let cgImage = originalImage?.cgImage else {
                return nil
            }
            bitmap.draw(cgImage, in: CGRect(origin: .zero, size: size))
            
            guard let rightPartImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return nil
            }
            bitmap.clear(CGRect(x: 0, y: 0, width: rightPatSize.width, height: rightPatSize.height))
            UIGraphicsEndImageContext()
            
            UIGraphicsBeginImageContext(size)
            guard let newBitmap = UIGraphicsGetCurrentContext()  else {
                UIGraphicsEndImageContext()
                return nil
            }
            
            guard let rightPartCgImage = rightPartImage.cgImage else {
                UIGraphicsEndImageContext()
                return nil
            }
            bitmap.translateBy(x: 0.0, y: size.height)
            newBitmap.scaleBy(x: 1.0, y: -1.0)
            newBitmap.draw(cgImage, in: CGRect(origin: CGPoint(x: 0, y: -size.height), size: size))
            newBitmap.draw(rightPartCgImage, in: CGRect(origin: CGPoint(x: rightPatSize.width, y: -rightPatSize.height), size: rightPatSize))
            
            let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
}
