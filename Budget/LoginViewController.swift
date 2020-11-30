//
//  LoginViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/11/30.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func login(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }
}
