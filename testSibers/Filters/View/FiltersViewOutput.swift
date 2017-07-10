//
//  FiltersViewOutput.swift
//  SibersTest
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit
protocol FiltersViewOutput {

    func viewIsReady()
    func select(_ image: UIImage)
    func selectDataProvider(at type: UIImagePickerControllerSourceType)
    func tapOriginlImage()
    func tabButtonSelectionImageProvider()
    func select(_ filter: Filter)
    func tapFilterImage()
    func tapSaveImage()
    func tapDeleteImage()
    func tapReuseImage()
}
