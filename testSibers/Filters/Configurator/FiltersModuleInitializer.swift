//
//  FiltersModuleInitializerInitializer.swift
//  SibersTest
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit

class FiltersModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var selectcodecountryViewController: FiltersViewController!

    override func awakeFromNib() {

        let configurator = FiltersModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: selectcodecountryViewController)
    }

}
