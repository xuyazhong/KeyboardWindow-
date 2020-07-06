//
//  LevelWindow.swift
//  KeyboardWindow
//
//  Created by xuyazhong on 2020/7/1.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

class LevelWindow: UIView {
    
    lazy var levelV: LevelAlertView = {
        var levelV: LevelAlertView = LevelAlertView(frame: CGRect(x: ScreenWidth/2-94, y: ScreenHeight/2-64, width: 188, height: 139))
        levelV.backgroundColor = .white
        levelV.round(radius: 4)
        levelV.publicV.addTarget(self, action: #selector(actionPublic), for: .touchUpInside)
        levelV.privateV.addTarget(self, action: #selector(actionPrivate), for: .touchUpInside)
        return levelV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .colorFromHex(0x000000, alpha: 0.6)
        addSubview(levelV)
    }
    
    @objc func actionPublic() {
        Services.sharedInstance.currentType = .PUBLIC_LEVEL
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTI_POST_LEVEL), object: nil)
        hide()
    }
    
    @objc func actionPrivate() {
        Services.sharedInstance.currentType = .PRIVATE_LEVEL
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTI_POST_LEVEL), object: nil)
        hide()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func hide() {
        removeFromSuperview()
    }
    
    @objc func show() {
        let keyWindow = getWindows() ?? UIApplication.shared.keyWindow!
        keyWindow.addSubview(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hide()
    }
    
    func getWindows() -> UIWindow? {
        for itemWindow in UIApplication.shared.windows {
            if let cls = NSClassFromString("UIRemoteKeyboardWindow") {
                if itemWindow.isKind(of: cls) {
                    print("itemWindow => \(itemWindow)")
                    return itemWindow
                }
            }
            
        }
        return nil
    }
    
    
}
