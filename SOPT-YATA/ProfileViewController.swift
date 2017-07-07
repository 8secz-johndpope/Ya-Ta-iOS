//
//  ProfileViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 2..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var profileData: ProfileResultData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInit()
        Network().getUserProfile { (result, data) in
            self.profileData = data
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setInit() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toDetail", sender: sender.tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "toDetail":
            let viewController  = segue.destination as! ProfileDetailViewController
            viewController.type = sender as! Int
        default:
            break
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "first", for: indexPath) as! ProfileFirstTableViewCell
            cell.profile = profileData
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "second", for: indexPath) as! ProfileSecondTableViewCell
            cell.profile = profileData
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        } else if indexPath.row == 1 {
            return 110
        }
        
        return tableView.rowHeight
    }
}
