//
//  Alert+Block.swift


import Foundation
import UIKit


enum AlertAction{
    case Ok
    case Cancel
}

typealias AlertCompletionHandler = ((_ index:AlertAction)->())?
typealias AlertCompletionHandlerInt = ((_ index:Int)->())

class Alert:UIViewController{

    
   class func showAlert(title:String?, message:String?){

    let topVC = UIApplication.topViewController()
    
    let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
    alert.addAction(UIAlertAction(title: "ok", style:.default, handler:nil))
        topVC?.present(alert, animated: true)
    }
    
    class func showAlertWithHandler(title:String?, message:String?, handler:AlertCompletionHandler){
        
        let topVC = UIApplication.topViewController()
        
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "ok", style:.default, handler: { (alert) in
            handler?(AlertAction.Ok)
        }))
        
        alert.addAction(UIAlertAction(title:"cancel", style:.default, handler: { (alert) in
            handler?(AlertAction.Cancel)
        }))
        topVC?.present(alert, animated: true)
    }
    
    
    class func showAlertWithHandler(title:String?, message:String?, okButtonTitle:String, handler:AlertCompletionHandler){
        
        let topVC = UIApplication.topViewController()
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:okButtonTitle, style:.default, handler: { (alert) in
            handler?(AlertAction.Ok)
        }))
        
        topVC?.present(alert, animated: true)
    }
    
    class func showAlertWithHandler(title:String?, message:String?, okButtonTitle:String, cancelButtionTitle:String,handler:AlertCompletionHandler){
        
        let topVC = UIApplication.topViewController()
        
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title:okButtonTitle, style:.default, handler: { (alert) in
            handler?(AlertAction.Ok)
        }))
        
        alert.addAction(UIAlertAction(title:cancelButtionTitle, style:.default, handler: { (alert) in
            handler?(AlertAction.Cancel)
        }))
        
        topVC?.present(alert, animated: true)
    }
    
    
    class func showAlertWithHandler(title:String?, message:String?, buttonsTitles:[String], showAsActionSheet: Bool,handler:@escaping AlertCompletionHandlerInt){
        
        showAlertWithHandler(title: title, message: message, buttonsTitles: buttonsTitles, showAsActionSheet: showAsActionSheet, handler: handler, tagValue: 0)

    }
    
    class func showAlertWithHandler(title:String?, message:String?, buttonsTitles:[String], showAsActionSheet: Bool,handler:@escaping AlertCompletionHandlerInt,tagValue:Int){
        
        let topVC = UIApplication.topViewController()
        
        let alert = UIAlertController(title:title, message: message, preferredStyle: (showAsActionSheet ?.actionSheet : .alert))
        for btnTitle in buttonsTitles{
            alert.addAction(UIAlertAction(title:btnTitle, style:.default, handler: { (alert) in
                handler(buttonsTitles.firstIndex(of: btnTitle)!)
            }))
        }
        
        topVC?.present(alert, animated: true)
    }



    class func showAlertWithIndicatorHandler(title:String?, message:String?, buttonsTitles:[String], showAsActionSheet: Bool,tagValue:Int,handler:@escaping AlertCompletionHandlerInt) {
        //create an alert controller
        let pending = UIAlertController(title: title, message: nil, preferredStyle: (showAsActionSheet ?.actionSheet : .alert))
        //create an activity indicator
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.isUserInteractionEnabled = false
        pending.view.addSubview(indicator)
        indicator.startAnimating()
        
        for btnTitle in buttonsTitles{
            pending.addAction(UIAlertAction(title:btnTitle, style:.default, handler: { (alert) in
                handler(buttonsTitles.firstIndex(of: btnTitle)!)
            }))
        }

        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.makeKeyAndVisible()
        vc.present(pending, animated: true, completion: nil)
        
//        UIApplication.topViewController()?.present(pending, animated: true)
    }

    class func hideAlertView(tagValue:Int){
        if let alert = UIApplication.topViewController() as? UIAlertController {
                alert.dismiss(animated: true, completion:nil)
        }
    }
}

