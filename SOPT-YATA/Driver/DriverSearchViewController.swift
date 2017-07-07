//
//  DriverSearchViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 5..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift

class DriverSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clickedView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var firstFrontLabel: UITextField!
    @IBOutlet weak var firstBackLabel: UITextField!
    @IBOutlet weak var lastFrontLabel: UITextField!
    @IBOutlet weak var lastBackLabel: UITextField!
    
    let viewType = Variable(0)
    let disposeBag = DisposeBag()
    
    let firstFrontPickerView = UIPickerView()
    let firstBackPickerView = UIPickerView()
    let lastFrontPickerView = UIPickerView()
    let lastBackPickerView = UIPickerView()
    
    let front = ["강원", "경기", "경남", "경북", "광주", "대구", "대전", "부산", "서울", "울산", "인천", "전남", "전북", "제주", "충남", "충북"]
    let back = [["강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군", "원주시", "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군", "화천군", "횡성군"],
                ["가평군", "고양시", "과천시", "광명시", "광주시", "구리시", "군포시", "김포시", "남양주시", "동두천시", "부천시", "성남시", "수원시", "시흥시", "안산시", "안성시", "안양시", "양평군", "여주군", "연천군", "오산시", "용인시", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"],
                ["거제시", "거창군", "고성군", "김해시", "남해군", "밀양시", "사천시", "산청군", "양산시", "의령군", "창녕군", "창원시", "통영시", "하동군", "함안군", "함양군", "합천군"],
                ["경산시", "경주시", "고령군", "구미시", "군위군", "김천시", "문경시", "봉화군", "상주시", "안동시", "영덕군", "양양군", "영주시", "영천시", "예천군", "울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군", "포항시", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"],
                ["광산구", "남구", "동구", "북구", "서구"],
                ["남구", "달서구", "달성군", "동구", "북구", "서구", "수성구", "중구"],
                ["대덕구", "동구", "서구", "유성구", "중구"],
                ["강서구", "금정구", "기장군", "남구", "동구", "동래구", "부산진구", "북구", "사상구", "사하구", "서구", "수영구", "연제구", "영도구", "중구", "해운대구"],
                ["강남구", "강동구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "중구", "중랑구"],
                ["남구", "동구", "북구", "울주군", "중구"],
                ["강화군", "계양구", "남구", "남동구", "동구", "부평구", "서구", "연수구", "옹진군", "중구"],
                ["강진군", "고흥군", "곡성구", "광양시", "구례군", "나주시", "담양군", "목포시", "무안군", "보성군", "순천시", "신안군", "여수시", "영광군", "영암군", "완도군", "장성군", "장흥군", "진도군", "함평군", "해남군", "화순군"],
                ["고창군", "군산시", "김제시", "남원시", "무주군", "부안군", "순창군", "완주군", "익산시", "임실군", "장수군", "전주시", "정읍시", "진안군"],
                ["서귀포시", "제주시"],
                ["계룡시", "공주시", "금산군", "논산시", "당진군", "보령시", "부여군", "서산시", "서천군", "아산시", "연기군", "예산군", "천안시", "청양군", "태안군", "홍성군"],
                ["괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "증평군", "진천군", "청원군", "청주시", "충주시"]]
    
    let firstFrontPickStatus = Variable(-1)
    var firstBackPickStatus = Variable(-1)
    let lastFrontPickStatus = Variable(-1)
    var lastBackPickStatus = Variable(-1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInit()
        addObserver()
    }
    
    private func setInit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        clickedView.isHidden = true
        headerView.setBorder(color: UIColor(red: 22.0 / 255.0, green: 73.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0))
        
        firstFrontPickerView.delegate = self
        firstBackPickerView.delegate = self
        lastFrontPickerView.delegate = self
        lastBackPickerView.delegate = self
        
        
        firstFrontPickerView.backgroundColor = UIColor.white
        firstFrontPickerView.showsSelectionIndicator = true
        firstBackPickerView.backgroundColor = UIColor.white
        firstBackPickerView.showsSelectionIndicator = true
        lastFrontPickerView.backgroundColor = UIColor.white
        lastFrontPickerView.showsSelectionIndicator = true
        lastBackPickerView.backgroundColor = UIColor.white
        lastBackPickerView.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = self.view.tintColor
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(done))
        doneButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 15.0)!], for: .normal)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        firstFrontLabel.inputView = firstFrontPickerView
        firstFrontLabel.inputAccessoryView = toolBar
        firstBackLabel.inputView = firstBackPickerView
        firstBackLabel.inputAccessoryView = toolBar
        lastFrontLabel.inputView = lastFrontPickerView
        lastFrontLabel.inputAccessoryView = toolBar
        lastBackLabel.inputView = lastBackPickerView
        lastBackLabel.inputAccessoryView = toolBar
    }
    
    func done() {
        firstFrontLabel.resignFirstResponder()
        firstBackLabel.resignFirstResponder()
        lastFrontLabel.resignFirstResponder()
        lastBackLabel.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeToView(_ sender: UIButton) {
        if sender.tag != viewType.value {
            viewType.value = sender.tag
        }
    }
    
    func addObserver() {
        viewType.asObservable().map { $0 }
            .subscribe(onNext: {
                self.changeView($0)
            }).disposed(by: disposeBag)
        
        firstFrontPickStatus.asObservable().map {
            if $0 == -1 {
                self.firstBackLabel.isEnabled = false
                return "시/도"
            }
            self.firstBackLabel.isEnabled = true
            self.firstBackPickerView.reloadAllComponents()
            return self.front[$0]
            }.bind(to: firstFrontLabel.rx.text)
            .addDisposableTo(disposeBag)
        firstBackPickStatus.asObservable().map {
            if $0 == -1 {
                return "시/군/구"
            }
            return self.back[self.firstFrontPickStatus.value][$0] }
            .bind(to: firstBackLabel.rx.text)
            .addDisposableTo(disposeBag)
        lastFrontPickStatus.asObservable().map {
            if $0 == -1 {
                self.lastBackLabel.isEnabled = false
                return "시/도"
            }
            self.lastBackLabel.isEnabled = true
            self.lastFrontPickerView.reloadAllComponents()
            return self.front[$0]
            }.bind(to: lastFrontLabel.rx.text)
            .addDisposableTo(disposeBag)
        lastBackPickStatus.asObservable().map {
            if $0 == -1 {
                return "시/군/구"
            }
            return self.back[self.lastFrontPickStatus.value][$0] }
            .bind(to: lastBackLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        Observable.combineLatest(firstFrontPickStatus.asObservable(), firstBackPickStatus.asObservable(), lastFrontPickStatus.asObservable(), lastBackPickStatus.asObservable()) {
            if (($0 != -1) && ($1 != -1) && ($2 != -1) && ($3 != -1)) {
                return true
            } else {
                return false
            }}.subscribe(onNext: {
                self.searchButton.isEnabled = $0
            }).disposed(by: disposeBag)
    }
    
    func changeView(_ sender: Int) {
        if sender == 0 {
            tableView.isHidden = false
            mapView.isHidden = true
            driverImage.isHidden = true
            mapButton.setImage(nil, for: .normal)
            mapButton.setTitle("지도", for: .normal)
            listButton.setImage(#imageLiteral(resourceName: "driverselect_list"), for: .normal)
            listButton.setTitle(nil, for: .normal)
        } else {
            tableView.isHidden = true
            mapView.isHidden = false
            driverImage.isHidden = false
            mapButton.setImage(#imageLiteral(resourceName: "driverselect_map"), for: .normal)
            mapButton.setTitle(nil, for: .normal)
            listButton.setImage(nil, for: .normal)
            listButton.setTitle("리스트", for: .normal)
        }
    }
    
    @IBAction func register(_ sender: UIView) {
        self.clickedView.isHidden = true
        let viewController = DriverRegisterViewController(nibName: "DriverRegisterViewController", bundle: nil)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.tabBarController?.present(viewController, animated: true, completion: nil)
    }
}

extension DriverSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "owner", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clickedView.isHidden = false
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension DriverSearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case firstFrontPickerView:
            return front.count
        case firstBackPickerView:
            if firstFrontPickStatus.value == -1 {
                return back[0].count
            }
            return back[firstFrontPickStatus.value].count
        case lastFrontPickerView:
            return front.count
        case lastBackPickerView:
            if lastFrontPickStatus.value == -1 {
                return back[0].count
            }
            return back[lastFrontPickStatus.value].count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case firstFrontPickerView:
            return front[row]
        case firstBackPickerView:
            if firstFrontPickStatus.value == -1 {
                return back[0][row]
            }
            return back[firstFrontPickStatus.value][row]
        case lastFrontPickerView:
            return front[row]
        case lastBackPickerView:
            if lastFrontPickStatus.value == -1 {
                return back[0][row]
            }
            return back[lastFrontPickStatus.value][row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case firstFrontPickerView:
            firstFrontPickStatus.value = row
        case firstBackPickerView:
            firstBackPickStatus.value = row
        case lastFrontPickerView:
            lastFrontPickStatus.value = row
        case lastBackPickerView:
            lastBackPickStatus.value = row
        default:
            break
        }
    }
}

