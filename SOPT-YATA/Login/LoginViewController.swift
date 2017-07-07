//
//  LoginViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 1..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    var passwordValid = Variable(false)
    var emailValid = Variable(false)
    
    var delegate: PresentDelegate? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLabel.rx.text.map {
            if $0!.isEmpty {
                self.passwordLabel.textColor = .red
                return false
            }
            self.passwordLabel.textColor = .green
            return true
            }.subscribe(onNext: {
                self.emailValid.value = $0
            }).disposed(by: disposeBag)
    
        passwordLabel.rx.text.map {
            if $0!.characters.count > 8 {
                self.passwordLabel.textColor = .green
                return true
            }
            self.passwordLabel.textColor = .red
            return false
            }.subscribe(onNext: {
                self.passwordValid.value = $0
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(passwordValid.asObservable(), emailValid.asObservable()) { $0 && $1 }
            .subscribe(onNext: {
                self.loginButton.isEnabled = $0
            }).disposed(by: disposeBag)
    }
    
    
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        Network().postLogin(emailLabel.text!, password: passwordLabel.text!) { (result, data) in
            if result {
                if let data = data {
                    if data.message == "success" {
                        UserDefaults.standard.set(data.result!.token, forKey: "token")
                        UserDefaults.standard.set(data.result!.profile!.id, forKey: "id")
                        UserDefaults.standard.set(self.passwordLabel.text!, forKey: "password")
                        UserDefaults.standard.set(data.result!.profile!.username, forKey: "username")
                        UserDefaults.standard.set(true, forKey: "login")
                        self.performSegue(withIdentifier: "toMain", sender: self)
                    }
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toJoin(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.presentJoin()
        }
    }
}
