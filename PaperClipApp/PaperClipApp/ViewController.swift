//
//  ViewController.swift
//  PaperClipApp
//
//  Created by Grinch on 06/11/2022.
//

import UIKit
import Model

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(Model().text)
    }
}

