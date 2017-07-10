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
        view.clearFilterImageView()
        view.showSpinner()
        interactor.apply(filter)
    }
    
    func select(_ image: UIImage) {
        interactor.setOriginal(image)
        view.setupOriginal(image)
        view.clearFilterImageView()
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
        if !interactor.isValidateTimer() {
            view.showChooseImageDataProvider()
        }
    }
    
    func tapFilterImage() {
        if interactor.getFilterImage() != nil {
            view.showChooseDoWithResult()
        }
    }
    
    func tapSaveImage() {
        interactor.saveImage()
    }
    
    func tapReuseImage() {
        view.setupOriginal(interactor.getFilterImage()!)
        interactor.setOriginal(interactor.getFilterImage()!)
        interactor.removeFilterImage()
        view.clearFilterImageView()
    }
    
    func tapDeleteImage() {
        interactor.removeFilterImage()
        view.clearFilterImageView()
    }
    
    
    //MARK: - Interactor output -
    func updateTime(at procent: Double) {
        view.updateSpinner(at: procent)
    }
    
    func setupFiltered(_ image: UIImage?) {
        view.removeSpinner()
        view.setupFiltered(image)
    }
}
