//
//  FiltersModuleConfigurator.swift
//  YoTask
//
//  Created by user on 05.07.17.
//  Copyright © 2017 Leonid. All rights reserved.
//

import UIKit

class FiltersModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? FiltersViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: FiltersViewController) {

        let router = FiltersRouter()

        let presenter = FiltersPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = FiltersInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
