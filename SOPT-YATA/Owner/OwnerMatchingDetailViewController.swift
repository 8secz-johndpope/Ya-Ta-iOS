//
//  OwnerMatchingDetailViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 2..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class OwnerMatchingDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: DriverDetailInformationResultData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInit()
    }
    
    private func setInit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        Network().putMatchingComplete(self.data?.applying_idx ?? 0) { (result) in
            if result {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension OwnerMatchingDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "destination", for: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! OwnerMatchingDetailSecondTableViewCell
            cell.driverData = data
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! OwnerMatchingDetailThirdTableViewCell
            cell.driverData = data
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        case 1:
            return 84
        case 2:
            return 140
        default:
            return tableView.rowHeight
        }
    }
}
