//
//  API.swift


//Alamofire Help Guide: https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#response-validation


import UIKit
import Alamofire

//MARK: API METHOD NAME

struct APIBaseURL {
    
    static let DemoURL = "https://api.invupos.com/invuApiPos/"
    // static let ProductionURL = "http://api-KrazyApp-job-portal.live"
    static let BaseUrl =  DemoURL //+ "api/v1/"
}

struct APIName {
    
   
    
    static let franquicias = "index.php?r=configuraciones/franquicias"
    static let menu = "index.php?r=menu"
    
}

struct APIConstant {
    static let parseErrorDomain   = "ParseError"
    static let parseErrorMessage  = "Unable to parse data"
    static let parseErrorCode     = Int(UInt8.max)
    static let content_type       = "Content-Type"
    static let Authorization      = "Authorization"
    static let content_value      = "application/x-www-form-urlencoded"
    static let content_value_Json = "application/json"
    static let AuthToken          = "Bearer "
    static let arySuccessCase     = ["200","201"]
    static let error_unexpected   = "We are sorry, something went wrong.\nPlease try again later"
    static let lang_type          = "lang-code"
    static let en                 = "en"
    static let ar                 = "ar"
    static let deviceType         = "device_type"
    static let deviceType_Value   = "IOS"
    static let android            = "Android"
}

//MARK:- Code Constant
//API Constants
let Cons_Status_Code_Success_200 = 200
let Cons_Status_Code_Success_201 = 201
let Cons_Status_Code_Failure_422 = 422
let Cons_Status_Code_Failure_404 = 404
let Cons_Status_Code_Failure_401 = 401

let arySuccessCode = [200,201]
let aryFailureCode = [422,404]

class API: NSObject {
    
    static let sharedInstance = API()
    
    private override init() {
        SMNetworkManager.shared.startNetworkReachabilityObserver()
    }
    
    //MARK: - Supporting Methods
    fileprivate func handleParseError(_ data: Data) -> Error{
        let error = NSError(domain:APIConstant.parseErrorDomain, code:APIConstant.parseErrorCode, userInfo:[ NSLocalizedDescriptionKey: APIConstant.error_unexpected])
        print(error.localizedDescription)
        do { //To print response if parsing fail
            let response  = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(response)
        }catch{}
        
        return error
    }
    
    //MARK: - Get HeaderParameter Method
    class func getHeaderParameter() -> HTTPHeaders {
        var httpHeaders = HTTPHeaders()
        httpHeaders.add(name: APIConstant.content_type, value: APIConstant.content_value_Json)
        httpHeaders.add(name: APIConstant.Authorization, value: "Bearer 5eeae49394cd929e299785c8805bd168fc675280") //TOKEN -: 5eeae49394cd929e299785c8805bd168fc675280
        return httpHeaders
    }
    
    class func handleFailureSuccess(baseClass:APIBaseClass) -> Bool{
        if APIConstant.arySuccessCase.contains(baseClass.statusCode){
            return true
        }
        return false
    }
    
    
    //HS:Custom API for exceptional case
    //MARK: DICTIONARY API
    func callCustomAPIWithModalClass<T:Decodable>(modelClass:T.Type, apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:HTTPHeaders? = nil, isInMainThread:Bool? = true, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void){
        
        let localIsInMainThread = isInMainThread ?? true
        if !SMNetworkManager.shared.isReachable! && localIsInMainThread{
            
            let view = Bundle.loadView(fromNib:"HSNetworkAlert", withType:HSNetworkAlert.self)
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    //showLoader()
                    self.callCustomAPIWithModalClass(modelClass: modelClass, apiName: apiName, requestType: requestType, paramValues: paramValues, headersValues: headersValues, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock)
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            //            if let viewToAdd = AppDelObj.window?.topMostController()?.view{
            //                view.frame = viewToAdd.bounds
            //                viewToAdd.addSubview(view)
            //            }
            // hideLoader()
            
            return
        }
        
        do {
            //URLEncoding.default
            AF.request("\(APIBaseURL.BaseUrl)\(apiName)", method: requestType, parameters: paramValues, encoding: JSONEncoding.default, headers: headersValues).response { (response) in
                
                if response.error != nil {
                    if localIsInMainThread {
                        //self.showToastMessage(title: response.error?.localizedDescription ?? "")
                        print(response.error?.localizedDescription ?? "")
                    }
                    FailureBlock(response.error!)
                }
                else{
                    guard let data = response.data else {
                        let error = self.handleParseError(Data())
                        if localIsInMainThread {
                            // self.showToastMessage(title: error.localizedDescription)
                            //print(error.localizedDescription)
                        }
                        FailureBlock(error)
                        return
                    }
                    do {
                        guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else {
                            return
                        }
                        
                        print("\n------------------------API URL---------------------\n","\(APIBaseURL.BaseUrl)\(apiName)")
                        print("\n------------------------API Request Parameters---------------------\n",paramValues as Any)
                        print("\n------------------------API Response---------------------\n",jsonResult as Any)
                        
                    } catch let error {
                        print(error)
                    }
                    if localIsInMainThread {
                        // self.showToastMessage(title: APIConstant.error_unexpected)
                        // print(APIConstant.error_unexpected)
                    }
                    do {
                        //
                        let objModalClass = try JSONDecoder().decode(modelClass,from: data)
                        print(objModalClass)
                        SuccessBlock(objModalClass)
                    } catch let error {
                        // if localIsInMainThread { self.showToastMessage(title: APIConstant.error_unexpected) }
                        FailureBlock(error)
                        print(error)
                    }
                }
            }
        }
    }
    
    //MARK: ARRAY API
    func callArrayAPIWithModalClass<T:Decodable>(modelClass:[T].Type, apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:HTTPHeaders? = nil, isInMainThread:Bool? = true, SuccessBlock:@escaping ([T]) -> Void, FailureBlock:@escaping (Error)-> Void){
        
        let localIsInMainThread = isInMainThread ?? true
        if !SMNetworkManager.shared.isReachable! && localIsInMainThread{
            
            let view = Bundle.loadView(fromNib:"HSNetworkAlert", withType:HSNetworkAlert.self)
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    //showLoader()
                    self.callArrayAPIWithModalClass(modelClass: modelClass, apiName: apiName, requestType: requestType, paramValues: paramValues, headersValues: headersValues, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock)
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            //            if let viewToAdd = AppDelObj.window?.topMostController()?.view{
            //                view.frame = viewToAdd.bounds
            //                viewToAdd.addSubview(view)
            //            }
            // hideLoader()
            
            return
        }
        
        do {
            //URLEncoding.default
            AF.request("\(APIBaseURL.BaseUrl)\(apiName)", method: requestType, parameters: paramValues, encoding: JSONEncoding.default, headers: headersValues).response { (response) in
                
                if response.error != nil {
                    if localIsInMainThread {
                        //self.showToastMessage(title: response.error?.localizedDescription ?? "")
                        print(response.error?.localizedDescription ?? "")
                    }
                    FailureBlock(response.error!)
                }
                else{
                    guard let data = response.data else {
                        let error = self.handleParseError(Data())
                        if localIsInMainThread {
                            // self.showToastMessage(title: error.localizedDescription)
                            //print(error.localizedDescription)
                        }
                        FailureBlock(error)
                        return
                    }
                    
                    do {
                         let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                        
                        print("\n------------------------API URL---------------------\n","\(APIBaseURL.BaseUrl)\(apiName)")
                        print("\n------------------------API Request Parameters---------------------\n",paramValues as Any)
                        print("\n------------------------API Response---------------------\n",jsonResult as Any)
                        
                    } catch let error {
                        print(error)
                    }
                    
                    if localIsInMainThread {
                        // self.showToastMessage(title: APIConstant.error_unexpected)
                        // print(APIConstant.error_unexpected)
                    }
                    do {
                        //
                        let objModalClass = try JSONDecoder().decode(modelClass,from: data)
                        print(objModalClass)
                        SuccessBlock(objModalClass)
                    } catch let error {
                        // if localIsInMainThread { self.showToastMessage(title: APIConstant.error_unexpected) }
                        FailureBlock(error)
                        print(error)
                    }
                }
            }
        }
    }
    
    
    
    //MARK: Upload API (Multi Part Api)
    
    func multipartRequestWithModalClass<T:Decodable>(modelClass:T.Type?,apiName:String, fileName:String,keyName:String,imgView:UIImageView,requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:HTTPHeaders? = nil, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void) {
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view = Bundle.loadView(fromNib:"HSNetworkAlert", withType:HSNetworkAlert.self)
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    //  self.showLoader()
                    self.multipartRequestWithModalClass(modelClass: modelClass, apiName: apiName, fileName: fileName, keyName: keyName, imgView: imgView, requestType: requestType, paramValues: paramValues, headersValues: headersValues, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock)
                    //  self.hideLoader()
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022){
                view.frame = viewToAdd.bounds
                viewToAdd.addSubview(view)
            }
            //  self.hideLoader()
            
            return
        }
        
        let image = imgView.image
        let imgData = image!.jpegData(compressionQuality: 0.5)
        
        let url = APIBaseURL.BaseUrl + apiName
        
        print("\n------------------------API URL---------------------\n",url)
        print("\n------------------------API Request Parameters---------------------\n",paramValues as Any)
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: keyName,fileName: fileName, mimeType: "image/\(imgData!.fileExtension))")
            for (key, value) in paramValues! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: url, method: .post, headers: headersValues)
        
        .responseDecodable(of: (modelClass ?? T.self).self)  { response in
            
            switch response.result {
                
            case .success(let upload):
                
                do {
                    guard let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else {
                        return
                    }
                    print("\n------------------------API Response---------------------\n",jsonResult as Any)
                    
                } catch let error {
                    print(error)
                }
                
                if((response.error) != nil){
                    print((response.error?.localizedDescription) as Any)
                    Alert.showAlert(title: (response.error?.localizedDescription), message: "")
                    FailureBlock(response.error!)
                }
                
                guard response.data != nil else {
                    FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                    return
                }
                
                SuccessBlock(upload)
                
            case .failure(let error):
                Alert.showAlert(title: "APP", message: error.errorDescription)
                FailureBlock(error)
            }
        }
        
    }
    
    func multipartsRequestWithModalClass<T:Decodable>(modelClass:T.Type?,apiName:String, fileName:[String],keyName:[String],isDocumnet:Bool,fileData:[Data?],requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues: HTTPHeaders, SuccessBlock:@escaping (T) -> Void, FailureBlock:@escaping (Error)-> Void) {
        
        if !(SMNetworkManager.shared.isReachable!) {
            
            let view  = UINib(nibName: "HSNetworkAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HSNetworkAlert
            view.handler = alertHandler({(index) in
                
                if (SMNetworkManager.shared.isReachable!){
                    view.removeFromSuperview()
                    //  self.showLoader()
                    self.multipartsRequestWithModalClass(modelClass: modelClass, apiName: apiName, fileName: fileName, keyName: keyName, isDocumnet: isDocumnet, fileData: fileData, requestType: requestType, paramValues: paramValues, headersValues: headersValues, SuccessBlock: SuccessBlock, FailureBlock: FailureBlock)
                    //self.hideLoader()
                }else{
                    
                    let viewAnimated = view.viewWithTag(7777)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! - 10, y: (viewAnimated?.center.y)!))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: (viewAnimated?.center.x)! + 10, y: (viewAnimated?.center.y)!))
                    viewAnimated?.layer.add(animation, forKey: "position")
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let viewToAdd = UIApplication.topViewController()?.view.viewWithTag(5022) ?? UIApplication.topViewController()?.view{
                    view.frame = viewToAdd.bounds
                    viewToAdd.addSubview(view)
                }
                //self.hideLoader()
            }
            
            return
        }
        
        let url = APIBaseURL.BaseUrl + apiName
        
        print("\n------------------------API URL---------------------\n",url)
        print("\n------------------------API Request Parameters---------------------\n",paramValues as Any)
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for (index,fData) in fileData.enumerated(){
                if let file = fData{
                    multipartFormData.append(file, withName: "\(keyName[index])", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                }
            }
            
            for (key, value) in paramValues! {
                print("\(key) + \(value)")
                
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            //            if fileData?.count ?? 0 > 0 {
            //                let split = fileName.components(separatedBy: ".")
            //                let fName = split[0] //?? "\(Date().timeIntervalSince1970).jpg"
            //                //let fType = split[1]
            //                var mType = ""
            //                if isDocumnet {
            //                    mType = "*/*"
            //                } else {
            //                    mType = "image/*"
            //                }
            //
            //                if let fData = fileData{
            //                    multipartFormData.append((fData), withName: keyName,fileName: fName, mimeType: mType)
            //                }
            //
            //                for (key, value) in paramValues! {
            //                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            //                }
            //
            //            } else {
            //                for (key, value) in paramValues! {
            //                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            //                }
            //
            //            }
            
        }, to: url, method: .post, headers: headersValues)
        
        .responseDecodable(of: (modelClass ?? T.self).self)  { response in
            
            switch response.result {
                
            case .success(let upload):
                
                do {
                    guard let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else {
                        return
                    }
                    print("\n------------------------API Response---------------------\n",jsonResult as Any)
                    
                } catch let error {
                    print(error)
                }
                
                if((response.error) != nil){
                    print((response.error?.localizedDescription) as Any)
                    Alert.showAlert(title: (response.error?.localizedDescription), message: "")
                    FailureBlock(response.error!)
                }
                
                guard response.data != nil else {
                    FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                    return
                }
                
                SuccessBlock(upload)
                
            case .failure(let error):
                Alert.showAlert(title: "APP", message: error.errorDescription)
                FailureBlock(error)
            }
        }
        
    }
  
}

public extension Data {
    var fileExtension: String {
        var values = [UInt8](repeating:0, count:1)
        self.copyBytes(to: &values, count: 1)
        
        let ext: String
        switch (values[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "png"
        }
        return ext
    }
}

protocol APIViewModelDelegate: class {
    func APISuccess()
    func APIFailure(message:String)
}

class APIBaseClass: Codable {
    
    let statusCode : String
    let message : String
    
    enum Keys: String, CodingKey {
        case statusCode = "status"
        case message = "message"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        statusCode = try values.decodeIfPresent(String.self, forKey: .statusCode) ?? "401"
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? APIConstant.error_unexpected
    }
    
}

extension Bundle {
    
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Could not load view with type " + String(describing: type))
    }
}

extension UIWindow {
    //     func topMostController() -> UIViewController? {
    //        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
    //            return nil
    //        }
    //        var topController = rootViewController
    //        while let newTopController = topController.presentedViewController {
    //            topController = newTopController
    //        }
    //        return topController
    //    }
}

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
}

func handleStatusCode(statusCode:Int,errorFromAPI:Errors?,meta:Meta?) -> Bool{
    
    var strAlert = ""
    
    if arySuccessCode.contains(statusCode) {
        return true
    } else if statusCode == Cons_Status_Code_Failure_401 {
        
        //self.hideLoader()
        //            logw(Cons_Status_401_msg)
        //            GlobalValue.sharedInstance.strUserType = String()
        //            self.LogoutFromApplication()
        return false
    } else if statusCode == Cons_Status_Code_Failure_422 {
        
        if meta?.message_code == "VALIDATION_ERROR"{
            if(errorFromAPI != nil){
                handleServersideValidation(errorFromAPI)
                return false
            }
            handleServersideValidation(errorFromAPI)
            return false
        } else if meta?.message_code == "INVALID_CREDENTIAL" {
            // Alert.showAlert(title: App_Name, message: meta?.message)
            return false
        } else if meta?.message_code == "USER_DOESNT_EXIST" {
            // Alert.showAlert(title: App_Name, message: meta?.message)
            return false
        } else if meta?.message_code == "ERROR" {
            // Alert.showAlert(title: App_Name, message: meta?.message)
            return false
        }
        else {
            // Alert.showAlert(title: App_Name, message: meta?.message)
            return false
        }
        return false
    } else if(aryFailureCode.contains(statusCode) && errorFromAPI != nil) {
        
        handleServersideValidation(errorFromAPI)
        return false
    } else {
        
        strAlert = (meta?.message) ?? ""
        
        print(strAlert)
        // Alert.showAlert(title: App_Name, message: strAlert)
        return false
    }
}

//MARK: ADD ERRORS HERE

//NOTE: - ASK SERVER SIDE ALL FIELD VALIDATION SHEET

fileprivate func handleServersideValidation(_ errorFromAPI: Errors?) {
    
    var strAlert = ""
    
    if ((errorFromAPI?.email) != nil){
        strAlert = (errorFromAPI?.email?.joined(separator: " and "))!
    }else if ((errorFromAPI?.email_id) != nil){
        strAlert = (errorFromAPI?.email_id?.joined(separator: " and "))!
    }else if ((errorFromAPI?.phone_number) != nil){
        strAlert = (errorFromAPI?.phone_number?.joined(separator: " and "))!
    }else if ((errorFromAPI?.device_type) != nil){
        strAlert = (errorFromAPI?.device_type?.joined(separator: " and "))!
    }else if ((errorFromAPI?.password) != nil){
        strAlert = (errorFromAPI?.password?.joined(separator: " and "))!
    }else if ((errorFromAPI?.name) != nil){
        strAlert = (errorFromAPI?.name?.joined(separator: " and "))!
    }else if ((errorFromAPI?.suitId) != nil){
        strAlert = (errorFromAPI?.suitId?.joined(separator: " and "))!
    }else if ((errorFromAPI?.insur_claims) != nil){
        strAlert = (errorFromAPI?.insur_claims?.joined(separator: " and "))!
    }else if ((errorFromAPI?.confirm_password) != nil){
        strAlert = (errorFromAPI?.confirm_password?.joined(separator: " and "))!
    }else if ((errorFromAPI?.new_password) != nil){
        strAlert = (errorFromAPI?.new_password?.joined(separator: " and "))!
    }else if ((errorFromAPI?.old_password) != nil){
        strAlert = (errorFromAPI?.old_password?.joined(separator: " and "))!
    }else if ((errorFromAPI?.work_phone) != nil){
        strAlert = (errorFromAPI?.work_phone?.joined(separator: " and "))!
    }else if ((errorFromAPI?.mobile_phone) != nil){
        strAlert = (errorFromAPI?.mobile_phone?.joined(separator: " and "))!
    }else if ((errorFromAPI?.home_phone) != nil){
        strAlert = (errorFromAPI?.home_phone?.joined(separator: " and "))!
    }else if ((errorFromAPI?.file) != nil){
        strAlert = (errorFromAPI?.file?.joined(separator: " and "))!
    } else if ((errorFromAPI?.otp) != nil){
        strAlert = (errorFromAPI?.otp?.joined(separator: " and "))!
    } else if ((errorFromAPI?.email_mobile) != nil){
        strAlert = (errorFromAPI?.email_mobile?.joined(separator: " and "))!
    } else if ((errorFromAPI?.first_name) != nil){
        strAlert = (errorFromAPI?.first_name?.joined(separator: " and "))!
    } else if ((errorFromAPI?.last_name) != nil){
        strAlert = (errorFromAPI?.last_name?.joined(separator: " and "))!
    } else if ((errorFromAPI?.address_id) != nil){
        strAlert = (errorFromAPI?.address_id?.joined(separator: " and "))!
    } else if ((errorFromAPI?.payment_mode) != nil){
        strAlert = (errorFromAPI?.payment_mode?.joined(separator: " and "))!
    } else if ((errorFromAPI?.vendor_id) != nil){
        strAlert = (errorFromAPI?.vendor_id?.joined(separator: " and "))!
        
    } else if ((errorFromAPI?.country_code) != nil){
        strAlert = (errorFromAPI?.country_code?.joined(separator: " and "))!
    } else if ((errorFromAPI?.latitudes) != nil){
        strAlert = (errorFromAPI?.latitudes?.joined(separator: " and "))!
    } else if ((errorFromAPI?.longitudes) != nil){
        strAlert = (errorFromAPI?.longitudes?.joined(separator: " and "))!
    } else if ((errorFromAPI?.building) != nil){
        strAlert = (errorFromAPI?.building?.joined(separator: " and "))!
        
    }  else if ((errorFromAPI?.user_account_name) != nil){
        strAlert = (errorFromAPI?.user_account_name?.joined(separator: " and "))!
        
    }
    else if ((errorFromAPI?.city) != nil){
        strAlert = (errorFromAPI?.city?.joined(separator: " and "))!
    }
    else if ((errorFromAPI?.contact_number) != nil){
        strAlert = (errorFromAPI?.contact_number?.joined(separator: " and "))!
    }
    else if ((errorFromAPI?.floor) != nil){
        strAlert = (errorFromAPI?.floor?.joined(separator: " and "))!
    }
    else if ((errorFromAPI?.street) != nil){
        strAlert = (errorFromAPI?.street?.joined(separator: " and "))!
    } else if ((errorFromAPI?.barcode) != nil) {
        strAlert = (errorFromAPI?.barcode?.joined(separator: " and "))!
    }else if ((errorFromAPI?.profile_images) != nil) {
        strAlert = (errorFromAPI?.profile_images?.joined(separator: " and "))!
    }
    
    print(strAlert)
    Alert.showAlert(title: "App_Name", message: strAlert)
    //showToastMessage(title:strAlert)
}

struct Meta : Codable {
    let status : Bool?
    let message : String?
    let message_code : String?
    let status_code : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case message_code = "message_code"
        case status_code = "status_code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        message_code = try values.decodeIfPresent(String.self, forKey: .message_code)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
    
}
