//
//  OwnerListViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 2..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class OwnerListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shortDetailView: DriverShortDetailView!
    @IBOutlet weak var unregisterButton: UIButton!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var data = [OwnerListResultData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInit()
    }
    
    private func setInit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.tableFooterView = UIView()
        shortDetailView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UserDefaults.standard.bool(forKey: "registerOwner") {
            unregisterButton.isHidden = true
            
            self.tableView.isHidden = true
            self.noDataView.isHidden = false
            self.noDataLabel.text = "첫번째 화면에서 등록해 주세요"
        } else {
            Network().getOwnerMatchingList(completionHandlers: { (result, data) in
                if let data = data {
                    if data.result.count > 0 && data.result[0].applying_created_at != "" {
                        self.data = data.result
                        DispatchQueue.main.async {
                            self.tableView.isHidden = false
                            self.noDataView.isHidden = true
                            self.tableView.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.tableView.isHidden = true
                            self.noDataView.isHidden = false
                            self.noDataLabel.text = "신청한 운전자가 없습니다"
                        }
                    }
                }
            })
            unregisterButton.isHidden = false
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unRegister(_ sender: UIButton) {
        Network().deleteOwnerMatching { (result) in
            if result {
                UserDefaults.standard.set(false, forKey: "registerOwner")
                self.unregisterButton.isHidden = true
                self.tableView.isHidden = true
                self.noDataView.isHidden = false
                self.noDataLabel.text = "첫번째 화면에서 등록해 주세요"
            }
        }
        
    }
    
    @IBAction func next(_ sender: UIButton) {
        Network().putMatchingApprove(self.shortDetailView.driverData?.applying_idx ?? 0) { (result) in
            self.shortDetailView.isHidden = true
            if result {
                self.performSegue(withIdentifier: "next", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "next":
            let destination = segue.destination as! OwnerMatchingDetailViewController
            destination.data = self.shortDetailView.driverData
        default:
            break
        }
    }
}

extension OwnerListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "driver", for: indexPath) as! OwnerMatchingTableViewCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shortDetailView.isHidden {
            Network().getDriverDetail(data[indexPath.row].applying_idx, completionHandlers: { (result, data) in
                if let data = data {
                    self.shortDetailView.driverData = data
                    self.shortDetailView.isHidden = false
                }
            })
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
