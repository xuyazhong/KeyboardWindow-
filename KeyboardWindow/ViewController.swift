//
//  ViewController.swift
//  KeyboardWindow
//
//  Created by xuyazhong on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(actionResult), name: NSNotification.Name(rawValue: Notification_POST), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func actionResult(_ noti: Notification) {
        if let result = noti.object as? String {
            print("result => \(result)")
        }
    }

    @IBAction func actionClick(_ sender: Any) {
        let xyz = XYZWindow(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        xyz.show()
    }
    
}

