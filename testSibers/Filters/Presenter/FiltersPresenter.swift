//
//  FiltersPresenter.swift
//  SibersTest
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit

enum Filter {
    case rotate, blackWhite, mirror, invertion, mirrorLeftOnRight
}

class FiltersPresenter: FiltersModuleInput, FiltersViewOutput, FiltersInteractorOutput {

    weak var view: FiltersViewInput!
    var interactor: FiltersInteractorInput!
    var router: FiltersRouterInput!
    
    //MARK: - View output -
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func select(_ filter: Filter) {
        interactor.apply(filter)
    }
    
    func select(_ image: UIImage) {
        interactor.setOriginal(image)
        view.setupOriginal(image)
        if interactor.isOriginalImage() {
            view.disabledFiltersAndShowImageView()
        }
    }
    
    func selectDataProvider(at type: UIImagePickerControllerSourceType) {
        view.showImagePickerController(at: type)
    }
    
    func tabButtonSelectionImageProvider() {
        view.showChooseImageDataProvider()
    }
    
    func tapOriginlImage() {
        view.showChooseImageDataProvider()
    }
    
    func tapFilterImage(at index: Int) {
        if interactor.getFilterImage(at: index) != nil {
            view.showChooseDoWithResult(at: index)
        }
    }
    
    func tapSaveImage(at index: Int) {
        interactor.saveImage(at: index)
    }
    
    func tapReuseImage(at index: Int) {
        view.setupOriginal(interactor.getFilterImage(at: index)!)
        interactor.setOriginal(interactor.getFilterImage(at: index)!)
    }
    
    func tapDeleteImage(at index: Int) {
        interactor.removeFilterImage(at: index)
        view.deleteViewModel(at: index)
    }
    
    //MARK: - Interactor output -
    func updateTime(at index: Int, procent: Double) {
        view.updateViewModel(at: index, viewModel: FilterImageViewModel(image: nil, procent: procent))
    }
    
    func setupFiltered(_ image: UIImage?, at index: Int) {
        let imageResize = resizeImage(image: image!, newWidth: 200.0)
        view.updateViewModel(at: index, viewModel: FilterImageViewModel(image: imageResize, procent: nil))
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        let context = UIGraphicsGetCurrentContext()
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        context?.clear(CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func addNewModel() {
       view.newViewModel(FilterImageViewModel(image: nil, procent: 0.0))
    }
    
    
}
