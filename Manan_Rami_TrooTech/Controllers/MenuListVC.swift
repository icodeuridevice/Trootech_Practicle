//
//  MenuListVC.swift
//  Manan_Rami_TrooTech
//
//  Created by Manan  on 26/05/22.
//

import UIKit
import Alamofire

class MenuListVC: UIViewController {
    
    // MARK: OUTLETS
    
    @IBOutlet weak var tableMenuList: UITableView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    // MARK: DECLARATIONS
    
    var objFranquicias : Franquicias?
    private var arrMenuList = [MenuData]()
    private var hiddenSections = Set<Int>()
    private var arrCategory = [String]()
    var num = 1
    var selectedPrice = ""
    var sum = 0.0
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callGetMenuListAPI()
        self.setupUIs()
    }
    
    // MARK: CUSTOM FUNCTIONS
    
    fileprivate func setupUIs(){
        self.title = objFranquicias?.negocio
        self.tableMenuList.register(UINib(nibName: "FranquiciaCell", bundle: nil), forCellReuseIdentifier: "FranquiciaCell")
    }
    
    func showPopup(){
        num = 1
        txtQty.text = String(num)
        viewPopup.isHidden = false
    }
    
    func hidePopup(){
        num = 1
        txtQty.text = String(num)
        viewPopup.isHidden = true
    }
    
    // MARK: ACTIONS
    
    @IBAction func action_Plus(_ sender: Any) {
        num += 1
        txtQty.text = String(num)
        let a  = Double(num)
        let b = Double(selectedPrice) ?? 0.0
        sum = a * b
        lblPrice.text = "\(sum)"
    }
    
    @IBAction func action_Minus(_ sender: Any) {
        num -= 1
        txtQty.text = String(num)
        let a  = Double(num)
        let b = Double(selectedPrice) ?? 0.0
        sum = a * b
        lblPrice.text = "\(sum)"
    }
    
    @IBAction func action_Confirm(_ sender: Any) {
        hidePopup()
        print(sum)
    }
    
    @IBAction func action_Cancel(_ sender: Any) {
        hidePopup()
    }
    
    
}

// MARK: TABLEVIEW METHODS

extension MenuListVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) {
            return 0
        }
        return self.arrCategory[section].count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        sectionButton.setTitle(self.arrCategory[section],for: .normal)
        sectionButton.backgroundColor = .systemBlue
        sectionButton.tag = section
        sectionButton.addTarget(self,action: #selector(self.hideSection(sender:)),for: .touchUpInside)
        return sectionButton
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FranquiciaCell") as! FranquiciaCell
        cell.lblName.text = self.arrMenuList[indexPath.row].nombre
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPopup()
        self.lblProductName.text = self.arrMenuList[indexPath.row].nombre ?? ""
        self.lblPrice.text = self.arrMenuList[indexPath.row].precioSugerido
        selectedPrice = self.arrMenuList[indexPath.row].precioSugerido ?? "0.0"
        
    }
    
    @objc
    private func hideSection(sender: UIButton) {
        let section = sender.tag
        
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            let rows = 0..<self.arrCategory[section].count
            
            _ = rows.map { row in
                indexPaths.append(IndexPath(row: row,section: section))
            }
            
            return indexPaths
        }
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.tableMenuList.insertRows(at: indexPathsForSection(), with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.tableMenuList.deleteRows(at: indexPathsForSection(), with: .fade)
        }
    }
    
    
}

// MARK: API CALLING 

extension MenuListVC {
    
    func callGetMenuListAPI(){
        
        let headers = ["APIKEY":"\(objFranquicias?.aPIKEY ?? "")"] as HTTPHeaders
        
        API.sharedInstance.callCustomAPIWithModalClass(modelClass: MenuModel.self, apiName: APIName.menu, requestType: .get, paramValues: nil,headersValues: headers) { response in
            
            self.arrMenuList = response.data ?? []
            
            var tempArray = [String]()
            
            _ = self.arrMenuList.map { model in
                tempArray.append(model.categoria?.nombremenu ?? "")
            }
            
            self.arrCategory = Array(Set(tempArray))
            
            DispatchQueue.main.async {
                self.tableMenuList.reloadData()
            }
            
        } FailureBlock: { error in
            print(error.localizedDescription)
        }
        
    }
    
}
