//
//  OwnereSettingViewController.swift
//  SOPT-YATA
//
//  Created by 안가현 on 2017. 7. 2..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class SettingViewController : UIViewController{
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        setInit()
    }
    
    private func setInit() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Application Cell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Myinformaion Cell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Service Cell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Marketing Cell", for: indexPath) as! MarketingTableViewCell
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Logout Cell", for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 130.0
        case 1, 2:
            return 155.0
        case 3:
            return 188.0
        case 4:
            return 70.0
        default:
            return tableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            UserDefaults.standard.set(false, forKey: "login")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = storyboard.instantiateInitialViewController() as! UINavigationController
            appDelegate.window?.makeKeyAndVisible()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}





