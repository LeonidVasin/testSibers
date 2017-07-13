//
//  FiltersInteractor.swift
//  SibersTest
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit
import CoreFoundation

class FiltersInteractor: FiltersInteractorInput {

    weak var output: FiltersInteractorOutput!
    
    fileprivate var filtersImages: [FilterImageModel] = []
    
    fileprivate var originalImage: UIImage?
    fileprivate let timeInteral: Double = 0.3
    
    func getRandomNumber() -> Double {
        return Double(arc4random_uniform(26)) + 5
    }
    
    @objc func updateTime(timer: Timer) {
        DispatchQueue.global(qos: .default).async {
            if let model = timer.userInfo as? FilterImageModel {
                model.currentTimeRender += self.timeInteral
                if let index = self.filtersImages.index(of: model) {
                    self.output.updateTime(at: index, procent: model.currentTimeRender/model.allTimeRender)
                }
                
                if model.currentTimeRender >= model.allTimeRender {
                    model.timer?.invalidate()
                    model.timer = nil
                    if let index = self.filtersImages.index(of: model) {
                        self.output.setupFiltered(model.image, at: index)
                    }
                }
            }
        }
    }
    
    //MARK: - Input protocol
    
    func isValidateTimer(at index: Int) -> Bool {
        return filtersImages[index].timer != nil
    }
    
    func isOriginalImage() -> Bool {
        return originalImage == nil ? false : true
    }
    
    func apply(_ filter: Filter) {
        let filterImage = FilterImageModel()
        filterImage.allTimeRender = self.getRandomNumber()
        filterImage.timer = Timer.scheduledTimer(timeInterval: self.timeInteral, target: self, selector: #selector(self.updateTime(timer:)), userInfo: filterImage, repeats: true)
        filtersImages.insert(filterImage, at: 0)
        output.addNewModel()
        DispatchQueue.global(qos: .default).async {
            switch filter {
            case .rotate:
                filterImage.image = self.applyRotateFilter()
            case .blackWhite:
                filterImage.image = self.applyBlackWhiteFilter()
            case .mirror:
                filterImage.image = self.applyMirrorFilter()
            case .invertion:
                filterImage.image = self.applyInvertionFilter()
            case .mirrorLeftOnRight:
                filterImage.image = self.applyMirrorLeftOnRightFilter()
            }
        }
    }
    
    func removeFilterImage(at index: Int) {
        filtersImages[index].timer?.invalidate()
        filtersImages.remove(at: index)
    }
    
    func setOriginal(_ image: UIImage) {
        originalImage = resizeImage(image)
    }
    
    func getFilterImage(at index: Int) -> UIImage? {
        return filtersImages[index].image
    }
    
    func saveImage(at index: Int) {
        UIImageWriteToSavedPhotosAlbum(filtersImages[index].image!, nil, nil, nil)
    }
}

extension FiltersInteractor {
    
    func resizeImage(_ image: UIImage) -> UIImage? {
        var size: CGSize = .zero
        if image.size.width > image.size.height {
            let scale = 2000 / image.size.width
            let newHeight = image.size.height * scale
            size = CGSize(width: 2000, height: newHeight)
        } else {
            let scale = 2000 / image.size.height
            let newWidth = image.size.width * scale
            size = CGSize(width: newWidth, height: 2000)
        }
        
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        let context = UIGraphicsGetCurrentContext()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        context?.clear(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
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
            bitmap.clear(CGRect(origin: origin, size: rotatedSize))
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
            
            let ciContext = CIContext(options: nil)
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
