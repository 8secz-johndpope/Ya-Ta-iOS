//
//  ProfileDetailViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 5..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileDetailViewController: UIViewController {
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var fourthView: UIView!
   
    @IBOutlet weak var ownerButton: UIButton!
    @IBOutlet weak var driverButton: UIButton!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var driverView: UIView!
    
    var type = 0
    
    let checker = Variable(0)
    let tableChecker = Variable(0)
    let disposeBag = DisposeBag()
    
    let background = UIColor(red: 129.0 / 255.0, green: 129.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
    let backgroundColor = UIColor(red: 129.0 / 255.0, green: 129.0 / 255.0, blue: 129.0 / 255.0, alpha: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        checker.asObservable().map { $0 }
            .subscribe(onNext: {
                self.changeView($0)
            }).disposed(by: disposeBag)
        
        tableChecker.asObservable().map { $0 }
            .subscribe(onNext: {
                self.changeTable($0)
            }).disposed(by: disposeBag)
        
        checker.value = type
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100

    }
    
    @IBAction func change(_ sender: UIButton) {
        if sender.tag != checker.value {
            checker.value = sender.tag
        }
    }
    
    @IBAction func tableChecker(_ sender: UIButton) {
        if sender.tag != tableChecker.value {
            tableChecker.value = sender.tag
        }
    }
    
    func changeTable(_ sender: Int) {
        if sender == 1 {
//            driverView.isHidden = false
//            ownerView.isHidden = true
//        } else {
//            driverView.isHidden = true
//            ownerView.isHidden = false
        }
        
        self.tableView.reloadData()
    }
    
    func changeView(_ sender: Int) {
        switch sender {
        case 0:
            firstButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            firstButton.setTitleColor(.black, for: .normal)
            firstButton.backgroundColor = backgroundColor
            secondButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            secondButton.setTitleColor(background, for: .normal)
            secondButton.backgroundColor = .white
            thirdButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            thirdButton.setTitleColor(background, for: .normal)
            thirdButton.backgroundColor = .white
            fourthButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            fourthButton.setTitleColor(background, for: .normal)
            fourthButton.backgroundColor = .white
            
            tableView.isHidden = true
            firstView.isHidden = false
            secondView.isHidden = true
            fourthView.isHidden = true
        case 1:
            secondButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            secondButton.setTitleColor(.black, for: .normal)
            secondButton.backgroundColor = backgroundColor
            firstButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            firstButton.setTitleColor(background, for: .normal)
            firstButton.backgroundColor = .white
            thirdButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            thirdButton.setTitleColor(background, for: .normal)
            thirdButton.backgroundColor = .white
            fourthButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            fourthButton.setTitleColor(background, for: .normal)
            fourthButton.backgroundColor = .white
            
            tableView.isHidden = true
            firstView.isHidden = true
            secondView.isHidden = false
            fourthView.isHidden = true
        case 2:
            thirdButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            thirdButton.setTitleColor(.black, for: .normal)
            thirdButton.backgroundColor = backgroundColor
            secondButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            secondButton.setTitleColor(background, for: .normal)
            secondButton.backgroundColor = .white
            firstButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            firstButton.setTitleColor(background, for: .normal)
            firstButton.backgroundColor = .white
            fourthButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            fourthButton.setTitleColor(background, for: .normal)
            fourthButton.backgroundColor = .white
            
            tableView.isHidden = false
            firstView.isHidden = true
            secondView.isHidden = true
            fourthView.isHidden = true
        case 3:
            fourthButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            fourthButton.setTitleColor(.black, for: .normal)
            fourthButton.backgroundColor = backgroundColor
            secondButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            secondButton.setTitleColor(background, for: .normal)
            secondButton.backgroundColor = .white
            thirdButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            thirdButton.setTitleColor(background, for: .normal)
            thirdButton.backgroundColor = .white
            firstButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            firstButton.setTitleColor(background, for: .normal)
            firstButton.backgroundColor = .white
            
            tableView.isHidden = true
            firstView.isHidden = true
            secondView.isHidden = true
            fourthView.isHidden = false
        default:
            break
        }
    }

}

extension ProfileDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableChecker.value == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "owner", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "driver", for: indexPath)
            return cell
        }
    }
}
