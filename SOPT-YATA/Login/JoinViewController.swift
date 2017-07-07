//
//  JoinViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 1..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol PresentDelegate {
    func presentJoin()
    func presentLogin()
}

class JoinViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    
    let placeholders = ["Password", "Confirm Password", "Phone Number", "Email Address"]
    var activeField: UITextField?
    
    var firstChecker = Variable(false)
    var secondChecker = Variable(false)
    var thirdChecker = Variable(false)
    var fourthChecker = Variable(false)
    var fifthChecker = Variable(false)
    var sixthChecker = Variable(false)
    
    let disposeBag = DisposeBag()
    
    var delegate: PresentDelegate? = nil
    var joinData = JoinData()
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        tableView.delegate = self
        tableView.dataSource = self
        addObserver()
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    func addObserver() {
        Observable.combineLatest(firstChecker.asObservable(), secondChecker.asObservable(), thirdChecker.asObservable(), fourthChecker.asObservable(), fifthChecker.asObservable(), sixthChecker.asObservable()) { $0 && $1 && $2 && $3 && $4 && $5 }
            .subscribe(onNext: {
                self.joinButton.isEnabled = $0
            }).disposed(by: disposeBag)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func join(_ sender: UIButton) {
        Network().postJoin(joinData) { (result, data) in
            if result {
                self.dismiss(animated: true) {
                    self.delegate?.presentLogin()
                }
            } else {
                // 실패 했을때는 어쩌지
            }
        }
    }
    
    @IBAction func toLogin(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.presentLogin()
        }
    }
    
}

extension JoinViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "twoType", for: indexPath) as! TwoTypeTableViewCell
            cell.idTextField.delegate = self
            cell.userNameTextField.delegate = self
            cell.idTextField.rx.text.map {
                self.joinData.id = $0!
                if $0!.isEmpty {
                    return false
                } else {
                    return true
                }}.subscribe(onNext: {
                    self.firstChecker.value = $0
                }).disposed(by: disposeBag)
            
            cell.userNameTextField.rx.text.map {
                self.joinData.username = $0!
                if $0!.isEmpty {
                    return false
                } else {
                    return true
                }}.subscribe(onNext: {
                    self.secondChecker.value = $0
                }).disposed(by: disposeBag)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "oneType", for: indexPath) as! OneTypeTableViewCell
            cell.inputTextField.placeholder = placeholders[indexPath.row - 1]
            
            switch indexPath.row - 1 {
            case 0, 1:
                cell.inputTextField.isSecureTextEntry = true
                cell.inputTextField.keyboardType = .default
            case 2:
                cell.inputTextField.isSecureTextEntry = false
                cell.inputTextField.keyboardType = .numberPad
            case 3:
                cell.inputTextField.isSecureTextEntry = false
                cell.inputTextField.keyboardType = .default
            default:
                cell.inputTextField.keyboardType = .default
                cell.inputTextField.isSecureTextEntry = false
            }
            
            cell.inputTextField.delegate = self
            cell.inputTextField.rx.text.map {
                let result = self.checkValidate(indexPath.row - 1, inputText: $0!)
    
                if indexPath.row - 1 == 0 {
                    if result {
                        cell.inputTextField.textColor = .green
                    } else {
                        cell.inputTextField.textColor = .red
                    }
                } else if indexPath.row - 1 == 1 {
                    if result {
                        cell.inputTextField.textColor = .green
                    } else {
                        cell.inputTextField.textColor = .red
                    }
                }
                return result
                }.subscribe(onNext: {
                    self.changeObserver(indexPath.row - 1, result: $0)
                }).disposed(by: disposeBag)
            return cell
        }
    }
    
    func checkValidate(_ tag: Int, inputText: String) -> Bool {
        switch tag {
        case 0:
            if inputText.isEmpty {
                return false
            } else {
                joinData.password = inputText
                if joinData.password.characters.count > 8 {
                    return true
                }
                return false
            }
        case 1:
            if inputText.isEmpty {
                return false
            } else {
                joinData.confirmPassword = inputText
                if joinData.confirmPassword == joinData.password {
                    return true
                } else {
                    return false
                }
            }
        case 2:
            if inputText.isEmpty {
                return false
            } else {
                joinData.phoneNumber = inputText
                return true
            }
        case 3:
            if inputText.isEmpty {
                return false
            } else {
                joinData.email = inputText
                if joinData.email.contains("@") {
                    return true
                }
                return false
            }
        default:
            break
        }
        return false
    }
    
    func changeObserver(_ tag: Int, result: Bool) {
        switch tag {
        case 0:
            self.thirdChecker.value = result
        case 1:
            self.fourthChecker.value = result
        case 2:
            self.fifthChecker.value = result
        case 3:
            self.sixthChecker.value = result
        default:
            break
        }
    }
}

extension JoinViewController: UITextFieldDelegate {
    func keyboardWasShown(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.tableView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.tableView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(64, 0.0, -keyboardSize!.height, 0.0)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}



