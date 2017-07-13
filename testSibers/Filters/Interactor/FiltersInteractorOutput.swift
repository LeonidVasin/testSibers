//
//  FiltersInteractorOutput.swift
//  SibersTest
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit

protocol FiltersInteractorOutput: class {
    func setupFiltered(_ image: UIImage?, at index: Int)
    func updateTime(at index: Int, procent: Double)
    func addNewModel()
}
