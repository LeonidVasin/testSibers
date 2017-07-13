//
//  FilterImageModel.swift
//  testSibers
//
//  Created by user on 11.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit

class FilterImageModel {
    var image: UIImage?
    var allTimeRender: Double = 0.0
    var currentTimeRender: Double = 0.0
    var isRender: Bool = true
    var timer: Timer?
}

extension FilterImageModel: Equatable {
    static func ==(lhs: FilterImageModel, rhs: FilterImageModel) -> Bool {
        if lhs.image == rhs.image {
            return true
        } else {
            return false
        }
    }
}
