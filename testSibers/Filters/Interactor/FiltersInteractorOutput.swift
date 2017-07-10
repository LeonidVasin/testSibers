//
//  FiltersInteractorOutput.swift
//  SibersTest
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit

protocol FiltersInteractorOutput: class {
    func setupFiltered(_ image: UIImage?)
    func updateTime(at procent: Double)
}
