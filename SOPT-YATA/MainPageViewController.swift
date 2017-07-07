//
//  MainPageViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 3..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefault = UserDefaults.standard
        let id = userDefault.string(forKey: "id") ?? ""
        let password = userDefault.string(forKey: "password") ?? ""
        
        Network().postLogin(id, password: password) { (result, data) in
            if result {
                if let data = data {
                    if data.message == "success" {
                        print("relogin")
                        UserDefaults.standard.set(data.result!.token, forKey: "token")
                        UserDefaults.standard.set(data.result!.profile!.id, forKey: "id")
                        UserDefaults.standard.set(data.result!.profile!.username, forKey: "username")
                    }
                }
            }
        }
    }

}
