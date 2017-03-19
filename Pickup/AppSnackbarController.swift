//
//  AppSnackbarController.swift
//  Pickup
//
//  Created by Ben Koska on 3/14/17.
//  Copyright © 2017 Koska. All rights reserved.
//

import UIKit
import Material

class AppSnackbarController: SnackbarController {
    open override func prepare() {
        super.prepare()
        delegate = self
    }
}

extension AppSnackbarController: SnackbarControllerDelegate {
    func snackbarController(snackbarController: SnackbarController, willShow snackbar: Snackbar) {}
    
    func snackbarController(snackbarController: SnackbarController, willHide snackbar: Snackbar) {}
    
    func snackbarController(snackbarController: SnackbarController, didShow snackbar: Snackbar) {}
    
    func snackbarController(snackbarController: SnackbarController, didHide snackbar: Snackbar) {}
}
