//
//  FiltersInteractorInput.swift
//  SibersTest
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit

protocol FiltersInteractorInput {
    func apply(_ filter: Filter)
    func setOriginal(_ image: UIImage)
    func isOriginalImage() -> Bool
    func removeFilterImage(at index: Int)
    func getFilterImage(at index: Int) -> UIImage?
    func saveImage(at index: Int)
    func isValidateTimer(at index: Int) -> Bool
}
