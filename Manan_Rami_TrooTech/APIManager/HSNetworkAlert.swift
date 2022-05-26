//
//  HSNetworkAlert.swift


import UIKit

typealias alertHandler = (( _ index:Int)->())?


class HSNetworkAlert: UIView {
    
    var handler: alertHandler!
    
    
    override func draw(_ rect: CGRect) {
//        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    }
    
    @IBAction func alertEvent(_ sender:UIButton){
        
        UIView.animate(withDuration: 0.2, animations: {self.alpha = 1.0},
                       completion: {(value: Bool) in
                        if self.handler != nil {
                            self.handler!!(sender.tag)
                        }
        })
    }
}
