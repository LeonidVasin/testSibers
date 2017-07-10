//
//  FiltersViewInput.swift
//  SibersTest
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//
import UIKit

protocol FiltersViewInput: class {

    func setupInitialState()
    func showImagePickerController(at type: UIImagePickerControllerSourceType)
    func showChooseImageDataProvider()
    func setupOriginal(_ image: UIImage)
    func setupFiltered(_ image: UIImage?)
    func disabledFiltersAndShowImageView()
    func showChooseDoWithResult()
    func clearFilterImageView()
    func updateSpinner(at procent: Double)
    func removeSpinner()
    func showSpinner()
}
