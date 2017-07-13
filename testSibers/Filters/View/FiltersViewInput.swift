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
    func disabledFiltersAndShowImageView()
    func showChooseDoWithResult(at index: Int)
    func updateViewModel(at index: Int, viewModel: FilterImageViewModel)
    func newViewModel(_ viewModel: FilterImageViewModel)
    func deleteViewModel(at index: Int)
    
}
