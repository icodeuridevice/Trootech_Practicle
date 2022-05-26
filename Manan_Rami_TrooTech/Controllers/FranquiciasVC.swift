//
//  ViewController.swift
//  Manan_Rami_TrooTech
//
//  Created by Manan  on 26/05/22.
//

import UIKit
import Alamofire

class FranquiciasVC: UIViewController {
    
    // MARK: OUTLETS
    
    @IBOutlet weak var tableFranquicias: UITableView!
    
    // MARK: DECLARATIONS
    
    private var arrFranquicias = [Franquicias]()

    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callGetFranquiciasListAPI()
        self.setupUIs()
    }

    // MARK: CUSTOM FUNCTIONS
    
    fileprivate func setupUIs(){
        self.tableFranquicias.register(UINib(nibName: "FranquiciaCell", bundle: nil), forCellReuseIdentifier: "FranquiciaCell")
    }

}

// MARK: TABLEVIEW METHODS

extension FranquiciasVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrFranquicias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FranquiciaCell") as! FranquiciaCell
        cell.lblName.text = self.arrFranquicias[indexPath.row].negocio
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "MenuListVC") as! MenuListVC
        obj.objFranquicias = self.arrFranquicias[indexPath.row]
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
}

// MARK: API CALLING 

extension FranquiciasVC {
    
    func callGetFranquiciasListAPI(){
        
        let headers = ["APIKEY":"bd_suvlascentralpos"] as HTTPHeaders
        
        API.sharedInstance.callCustomAPIWithModalClass(modelClass: FranquiciasModel.self, apiName: APIName.franquicias, requestType: .get, paramValues: nil,headersValues: headers) { response in
            
            self.arrFranquicias = response.franquicias ?? []
            
            DispatchQueue.main.async {
                self.tableFranquicias.reloadData()
            }
            
        } FailureBlock: { error in
            print(error.localizedDescription)
        }

    }
    
}
