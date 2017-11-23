//
//  ViewController.swift
//  Alerts
//
//  Created by StanDimitroff on 11/22/2017.
//  Copyright (c) 2017 StanDimitroff. All rights reserved.
//

import UIKit
import Alerts

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showAlert(_ sender: UIButton) {
        let alert = Alert.makeAlert(
            title: "Change background",
            message: "Background colour will be changed",
            presenter: self)

        alert.actions = [
            Action(
                "Confirm",
                responders: [
                    {
                        self.view.backgroundColor = .cyan
                    }
                ]),
            Action("Cancel")
        ]
        
        alert.show()
    }

    @IBAction func showAction(_ sender: UIButton) {
        let action = Alert.makeActionSheet(presenter: self)
        action.actions = [
            Action(
                "Change background",
                responders: [
                    {
                        self.view.backgroundColor = .magenta
                    }
                ])
        ]

        action.show()
    }
}

